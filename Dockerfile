FROM python:2.7
ENV DockerHOME=/home/app/webapp \
    DB_ENGINE='django.db.backends.postgresql_psycopg2' \
    DB_NAME='janvi' \
    DB_USER='janvi' \
    DB_PASSWORD='janvi' \
    DB_HOST='postgresdb' \
    DB_PORT='5432'
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt 
RUN pip install psycopg2
EXPOSE 8080
CMD notejam/manage.py syncdb --noinput && notejam/manage.py migrate && notejam/manage.py runserver 0.0.0.0:8080
