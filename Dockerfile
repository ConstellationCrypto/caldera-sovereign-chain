FROM rust:1.88.0 AS builder

WORKDIR /usr/local/src/rollup-starter

# Project build source
COPY Cargo.toml .
COPY Cargo.lock .
COPY rust-toolchain.toml .
COPY .cargo ./.cargo
COPY crates ./crates
COPY examples ./examples
COPY scripts ./scripts

# Project build configuration
# NOTE: there are rollup-specific constants in here that need to be overridden properly i.e. chain id, name, etc.
COPY constants.toml .

# Other build source
RUN apt update && apt install -y libclang-dev

# Project build; celestia, mock_zkvm as the caldera standard
# TODO: Investigate what will need to change here to go with a real zk-proving setup
RUN cargo build --no-default-features --features=celestia_da,mock_zkvm --release

FROM debian:12-slim

# Copy the build artifact
COPY --from=builder /usr/local/src/rollup-starter/target/release/rollup /usr/local/bin/rollup


ENTRYPOINT ["rollup"]
