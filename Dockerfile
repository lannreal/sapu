FROM node:20-slim

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# welcome script
COPY lann-welcome.sh /root/lann-welcome.sh
RUN chmod +x /root/lann-welcome.sh && \
    echo "bash /root/lann-welcome.sh" >> /root/.bashrc

CMD ["npm", "start"]
