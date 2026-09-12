COPY lann-welcome.sh /root/lann-welcome.sh
RUN chmod +x /root/lann-welcome.sh && \
    echo "bash /root/lann-welcome.sh" >> /root/.bashrc