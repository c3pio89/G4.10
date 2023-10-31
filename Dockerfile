# Базовый образ
FROM python:3.8-slim-buster

# Добавление репозитория PostgreSQL и ключей аутентификации
RUN apt-get update && \
    apt-get install -y wget gnupg && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    nginx \
    postgresql-15 \
    postgresql-contrib-15 \
    gcc \
    gosu \
    && rm -rf /var/lib/apt/lists/*

# Копирование requirements.txt в образ
COPY requirements.txt /tmp/

# Установка зависимостей из файла requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Копирование проекта Django
COPY . /app

# Установка рабочей директории
WORKDIR /app

# Копирование конфигураций
COPY gunicorn_config.py /app/gunicorn_config.py
COPY nginx.conf /etc/nginx/sites-available/default

# Копирование скрипта start.sh
COPY start.sh /app/start.sh

# Делаем скрипт start.sh исполняемым
RUN chmod +x /app/start.sh

# Запуск скрипта start.sh
CMD ["/app/start.sh"]
