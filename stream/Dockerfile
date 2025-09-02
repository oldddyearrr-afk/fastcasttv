# استخدم Ubuntu مع nginx و ffmpeg
FROM ubuntu:22.04

# تثبيت nginx و ffmpeg و curl
RUN apt-get update && apt-get install -y \
    nginx \
    ffmpeg \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# إنشاء مجلد العمل
WORKDIR /app

# نسخ الملفات من مجلد stream
COPY stream/start.sh /app/start.sh
COPY stream/nginx.conf /app/nginx.conf.template
COPY stream/hls /app/hls

# اعطاء صلاحية التنفيذ لـ start.sh
RUN chmod +x /app/start.sh

# إنشاء مجلدات مؤقتة لـ nginx logs و temp
RUN mkdir -p /tmp/client_temp /tmp/proxy_temp /tmp/fastcgi_temp /tmp/uwsgi_temp /tmp/scgi_temp

# فتح البورت (Koyeb يستخدم متغير PORT)
EXPOSE 80

# تشغيل start.sh عند بدء الحاوية
CMD ["/app/start.sh"]
