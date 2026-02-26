FROM debian:bookworm

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    wget \
    unzip \
    ca-certificates \
    qemu-system-x86-64 \
    && rm -rf /var/lib/apt/lists/*

# Install Tailscale
RUN curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list && \
    apt-get update && \
    apt-get install -y tailscale

# Download Windows 11 image
RUN curl -L -o /w11.img "https://is.gd/win11_tiny"

# Create and set permissions for a startup script
RUN touch /start.sh && chmod +x /start.sh

# The startup script
RUN echo '#!/bin/bash' >> /start.sh && \
    echo 'tailscaled &' >> /start.sh && \
    echo 'tailscale up --authkey=${TS_AUTHKEY} --hostname=windows-vm &' >> /start.sh && \
    echo 'qemu-system-x86_64 -hda /w11.img -m 4G -smp cores=2 -net user,hostfwd=tcp::3389-:3389 -net nic -object rng-random,id=rng0,filename=/dev/urandom -device virtio-rng-pci,rng=rng0 -vga vmware -nographic' >> /start.sh

# Command to run on container start
CMD ["/bin/bash", "/start.sh"]
