# First Stage - Build Stage
FROM golang:1.22.5 AS base

WORKDIR /app

# Copy go.mod and download dependencies
COPY go.mod .
RUN go mod download

# Copy the rest of the application source code
COPY . .

# Build the Go application
RUN go build -o main .

# Final Stage - Distroless Image
FROM gcr.io/distroless/base

WORKDIR /app

# Copy the compiled binary and static files from the build stage
COPY --from=base /app/main .
COPY --from=base /app/static ./static

# Expose port 8080
EXPOSE 8080

# Command to run the application
CMD ["./main"]
