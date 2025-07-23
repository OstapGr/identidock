FROM python:3

RUN groupadd -r uwsgi && useradd -r -g uwsgi uwsgi
RUN pip install Flask uWSGI requests redis
WORKDIR /app
COPY app /app
COPY cmd.sh /

EXPOSE 9090 9191
USER uwsgi

CMD ["/cmd.sh"]
# CMD ["uwsgi", "--http", "0.0.0.0:9090", "--wsgi-file", "identidock.py", \
# "--callable", "app", "--stats", "0.0.0.0:9191"]
# CMD ["python", "identidock.py"]
