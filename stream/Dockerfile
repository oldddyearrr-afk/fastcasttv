# ======= Base Image =======
FROM ubuntu:22.04

# ======= تحديث النظام وتثبيت الأدوات =======
RUN apt-get update && apt-get install -y \
    nginx \
    ffmpeg \
    bash \
    curl \
    && rm -rf /var/lib/apt/lists/*

# ======= إنشاء مجلد العمل =======
WORKDIR /app

# ======= نسخ ملفات المشروع =======
COPY start.sh /app/start.sh
COPY nginx.conf /app/nginx.conf

# جعل start.sh قابل للتنفيذ
RUN chmod +x /app/start.sh

# إنشاء مجلد HLS للبث
RUN mkdir -p /app/hls

# ======= تعيين متغير البيئة للرابط الأصلي =======
ENV SOURCE_URL="http://188.241.219.157/ulke.bordo1453.befhjjjj/Orhantelegrammmm30conextionefbn/274122?token=ShJdY2ZmQQNHCmMZCDZXUh9GSHAWGFMD.ZDsGQVN.WGBFNX013GR9YV1QbGBp0QE9SWmpcXlQXXlUHWlcbRxFACmcDY1tXEVkbVAoAAQJUFxUbRFldAxdeUAdaVAFcUwcHAhwWQlpXQQMLTFhUG0FQQU1VQl4HWTsFVBQLVABGCVxEXFgeEVwNZgFcWVlZBxcDGwESHERcFxETWAxCCQgfEFNZQEBSRwYbX1dBVFtPF1pWRV5EFExGWxMmJxVJRlZKRVVaQVpcDRtfG0BLFU8XUEpvQlUVQRYEUA8HRUdeEQITHBZfUks8WgpXWl1UF1xWV0MSCkQERk0TDw1ZDBBcQG5AXVYRCQ1MCVVJ"

# ======= كشف المنفذ =======
EXPOSE 5000

# ======= تشغيل start.sh =======
CMD ["bash", "/app/start.sh"]
