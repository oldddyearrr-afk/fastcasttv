#!/bin/bash
# تنظيف شامل
pkill -f nginx 2>/dev/null || true
pkill -f ffmpeg 2>/dev/null || true
sleep 3

SOURCE_URL="http://1789-181.123091763.it.com/live/710135_.m3u8"
WORK_DIR="/app"
STREAM_DIR="$WORK_DIR/stream"
HLS_DIR="$STREAM_DIR/hls"
LOGS_DIR="$STREAM_DIR/logs"
NGINX_CONF="/etc/nginx/nginx.conf"
PORT=${PORT:-8000}

# استبدال البورت داخل Nginx config
sed -i "s/PORT_PLACEHOLDER/$PORT/" "$NGINX_CONF"

# تنظيف مجلد HLS
mkdir -p "$LOGS_DIR" 2>/dev/null || true
find "$HLS_DIR" -name "*.ts" -delete 2>/dev/null || true
find "$HLS_DIR" -name "*.m3u8" -delete 2>/dev/null || true

# تشغيل nginx
nginx &
NGINX_PID=$!
sleep 2

# تشغيل ffmpeg
ffmpeg -hide_banner -loglevel error \
    -fflags +genpts \
    -user_agent "Mozilla/5.0 (compatible; Stream/1.0)" \
    -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -reconnect_delay_max 10 \
    -rw_timeout 10000000 \
    -i "$SOURCE_URL" \
    -c:v copy -c:a copy \
    -f hls -hls_time 4 -hls_list_size 8 \
    -hls_flags program_date_time+delete_segments+independent_segments \
    -hls_segment_filename "$HLS_DIR/seg_%03d.ts" \
    "$HLS_DIR/playlist.m3u8" &

FFMPEG_PID=$!

# مراقبة FFmpeg وتنظيف segments
monitor_ffmpeg() {
    while true; do
        sleep 30
        if ! kill -0 $FFMPEG_PID 2>/dev/null; then
            echo "🔄 FFmpeg crashed, restarting..."
            ffmpeg -hide_banner -loglevel error \
                -fflags +genpts \
                -user_agent "Mozilla/5.0 (compatible; Stream/1.0)" \
                -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -reconnect_delay_max 10 \
                -rw_timeout 10000000 \
                -i "$SOURCE_URL" \
                -c:v copy -c:a copy \
                -f hls -hls_time 4 -hls_list_size 8 \
                -hls_flags program_date_time+delete_segments+independent_segments \
                -hls_segment_filename "$HLS_DIR/seg_%03d.ts" \
                "$HLS_DIR/playlist.m3u8" &
            FFMPEG_PID=$!
        fi
    done
}

cleanup_segments() {
    while true; do
        sleep 20
        SEGMENT_COUNT=$(ls -1 "$HLS_DIR"/seg_*.ts 2>/dev/null | wc -l)
        if [ "$SEGMENT_COUNT" -gt 10 ]; then
            ls -1t "$HLS_DIR"/seg_*.ts | tail -n +11 | xargs rm -f 2>/dev/null || true
        fi
    done
}

monitor_ffmpeg & cleanup_segments &
MONITOR_PID=$!; CLEANUP_PID=$!

cleanup() {
    kill $FFMPEG_PID $NGINX_PID $MONITOR_PID $CLEANUP_PID 2>/dev/null || true
    exit 0
}
trap cleanup SIGTERM SIGINT

while true; do sleep 60; done
