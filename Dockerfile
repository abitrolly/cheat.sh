FROM alpine:3.12
# fetching cheat sheets
## installing dependencies
RUN apk add --update --no-cache git py3-six py3-pygments py3-yaml py3-gevent \
      libstdc++ py3-colorama py3-requests py3-icu py3-redis
## building missing python packages
RUN apk add --no-cache --virtual build-deps py3-pip g++ python3-dev \
    && pip3 install --no-cache-dir rapidfuzz colored polyglot pycld2 \
    && apk del build-deps
## copying
WORKDIR /app
COPY . /app
RUN mkdir -p /root/.cheat.sh/log/ \
    && python3 lib/fetch.py fetch-all

# installing server dependencies
RUN apk add --update --no-cache py3-jinja2 py3-flask bash gawk

ENV CHEATSH_CACHE_TYPE=none
ENV FLASK_ENV=development
#ENV FLASK_RUN_RELOAD=False
ENV FLASK_APP="bin/srv.py"
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=8002

ENTRYPOINT ["/usr/bin/flask", "run"]
