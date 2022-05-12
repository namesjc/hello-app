#Build stage
FROM golang:alpine AS builder
WORKDIR /app
COPY ./app/* .
RUN go build -o main main.go

#Run stage
FROM alpine
WORKDIR /app
COPY --from=builder /app/main .

EXPOSE 8080
CMD ["/app/main"]

