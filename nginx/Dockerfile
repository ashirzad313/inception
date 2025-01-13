FROM debian:buster

RUN apt -y update && apt install -y nginx openssl

COPY ./script.sh /

CMD ["/script.sh"]
