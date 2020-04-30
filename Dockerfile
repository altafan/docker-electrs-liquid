FROM rust:stretch AS builder

RUN apt-get update
RUN apt-get install -y clang cmake

RUN git clone https://github.com/blockstream/electrs

WORKDIR /electrs

RUN cargo build --features liquid --release --bin electrs

FROM debian:stable-slim

WORKDIR /build

COPY --from=builder /electrs/target/release/electrs /build

EXPOSE 3002
EXPOSE 60401

STOPSIGNAL SIGINT

ENTRYPOINT ["/build/electrs"]
CMD ["-vvvv", "--daemon-dir", "/config", "--http-addr", "0.0.0.0:3002"]
