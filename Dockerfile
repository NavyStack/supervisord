# -------- Build Stage --------
FROM golang:1.24.5-bookworm AS builder

ENV CGO_ENABLED=0 \
    GOOS=linux

WORKDIR /app

COPY . .

RUN go mod download

RUN go build -tags "netgo osusergo" \
  -ldflags="-s -w -extldflags=-static" \
  -o supervisord

FROM scratch AS final

COPY --from=builder /app/supervisord /usr/local/bin/supervisord

ENTRYPOINT ["supervisord"]
