# ==================================================
# Dockerfile para Frontend Angular - GLE
# ==================================================

# Usar a imagem oficial do Node.js
FROM node:18-alpine

# Informações do mantenedor
LABEL maintainer="Embras TI"
LABEL description="Frontend Angular com PrimeNG para o sistema GLE"

# Instalar Angular CLI globalmente
RUN npm install -g @angular/cli

# Definir diretório de trabalho
WORKDIR /app

# Copiar package.json e package-lock.json
COPY package*.json ./

# Instalar dependências
RUN npm install

# Copiar o código da aplicação
COPY . .

# Expor a porta do Angular
EXPOSE 4005

# Comando padrão
CMD ["ng", "serve", "--host", "0.0.0.0", "--port", "4005", "--poll", "2000"]
