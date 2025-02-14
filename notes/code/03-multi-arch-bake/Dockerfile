FROM --platform=$BUILDPLATFORM golang:1.22-alpine AS builder

WORKDIR /app
COPY main.go .
COPY go.mod .

ARG TARGETOS
ARG TARGETARCH

RUN <<EOF
go mod tidy 
GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o tiny-service
EOF

FROM scratch

WORKDIR /app

COPY --from=builder /app/tiny-service .
COPY public ./public 
CMD ["./tiny-service"]