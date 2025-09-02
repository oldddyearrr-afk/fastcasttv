FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    nginx \
    ffmpeg \
    bash \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# نسخ الملفات من مجلد stream في GitHub
COPY stream/start.sh /app/start.sh
COPY stream/nginx.conf /app/nginx.conf
COPY stream/hls /app/hls

RUN chmod +x /app/start.sh

ENV SOURCE_URL="http://188.241.219.157/ulke.bordo1453.befhjjjj/Orhantelegrammmm30conextionefbn/274122?token=ShJdY2ZmQQNHCmMZCDZXUh9GSHAWGFMD.ZDsGQVN.WGBFNX013GR9YV1QbGBp0QE9SWmpcXlQXXlUHWlcbRxFACmcDY1tXEVkbVAoAAQJUFxUbRFldAxdeUAdaVAFcUwcHAhwWQlpXQQMLTFhUG0FQQU1VQl4HWTsFVBQLVABGCVxEXFgeEVwNZgFcWVlZBxcDGwESHERcFxETWAxCCQgfEFNZQEBSRwYbX1dBVFtPF1pWRV5EFExGWxMmJxVJRlZKRVVaQVpcDRtfG0BLFU8XUEpvQlUVQRYEUA8HRUdeEQITHBZfUks8WgpXWl1UF1xWV0MSCkQERk0TDw1ZDBBcQG5AXVYRCQ1MCVVJ"

EXPOSE 5000

CMD ["/app/start.sh"]
