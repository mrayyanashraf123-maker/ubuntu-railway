FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends sudo wget curl git python3 python3-pip neofetch ca-certificates bash && \
    curl -fsSL https://ollama.com/install.sh | sh && \
    useradd -m -s /bin/bash ubuntu && \
    echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget -qO /bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /bin/ttyd

RUN printf '%s\n' 'neofetch' 'cd /root' >> /root/.bashrc

EXPOSE $PORT

CMD ["/bin/bash", "-c", "set -e; ollama serve >/tmp/ollama.log 2>&1 & echo $! >/tmp/ollama.pid; sleep 1; exec /bin/ttyd -p ${PORT:-8080} -c ${USERNAME:-ubuntu}:${PASSWORD:-ubuntu} /bin/bash"]
