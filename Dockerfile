FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install base tools + Docker CLI + Python
RUN apt update && apt install -y \
    curl \
    wget \
    git \
    nano \
    sudo \
    ca-certificates \
    lsb-release \
    python3 \
    python3-pip \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /app

# Create simple web server file
RUN echo 'import os\n\
from http.server import SimpleHTTPRequestHandler\n\
from socketserver import TCPServer\n\
PORT = int(os.environ.get("PORT", 8080))\n\
Handler = SimpleHTTPRequestHandler\n\
with TCPServer(("0.0.0.0", PORT), Handler) as httpd:\n\
    print("Server running on port", PORT)\n\
    httpd.serve_forever()' > server.py

# Expose Railway port
EXPOSE 8080

# Start web server
CMD ["python3", "server.py"]
