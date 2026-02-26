RUN echo '#!/bin/bash' >> /start.sh && \
    echo 'tailscaled &' >> /start.sh && \
    echo 'tailscale up --authkey=${TS_AUTHKEY} --hostname=windows-vm &' >> /start.sh && \
    echo 'qemu-system-x86_64 -hda /w11.img -m 4G ...' >> /start.sh
