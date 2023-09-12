FROM rust:1.40-slim

WORKDIR /app
COPY . .

WORKDIR /app/rustls/test-ca

RUN bash build-a-pki.sh

WORKDIR /app/client-hello-poisoning/custom-tls

RUN apt-get update && apt-get install curl -y
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
RUN rustup default stable
RUN cargo build
RUN cargo install --path .

ENV CERTS /app/rustls/test-ca/rsa/end.fullchain
ENV KEY /app/rustls/test-ca/rsa/end.rsa

CMD ["sh", "-c", "/usr/local/cargo/bin/custom-tls --verbose --certs $CERTS --key $KEY -p 443 http"]
