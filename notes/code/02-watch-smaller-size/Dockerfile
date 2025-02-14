# ADD `AS builder`
FROM golang:1.22-alpine AS builder 

WORKDIR /app
COPY main.go .
COPY go.mod .

RUN <<EOF
go mod tidy 
go build -o tiny-service
EOF

#FROM scratch as final
#FROM gcr.io/distroless/static-debian12 as final
# INSERT this part
FROM alpine:3.19 AS final
WORKDIR /app
COPY --from=builder /app/tiny-service .

# KEEP this part
COPY public ./public 
CMD ["./tiny-service"]
