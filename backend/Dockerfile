# ==================================================
# Dockerfile para Backend Ruby on Rails - GLE
# ==================================================

# Usar a imagem oficial do Ruby
FROM ruby:3.2-alpine

# Informações do mantenedor
LABEL maintainer="Embras TI"
LABEL description="Backend API Ruby on Rails para o sistema GLE"

# Instalar dependências do sistema
RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    postgresql-client \
    tzdata \
    nodejs \
    yarn \
    git

# Definir diretório de trabalho
WORKDIR /app

# Copiar Gemfile e Gemfile.lock
COPY Gemfile* ./

# Instalar gems
RUN bundle config set --local without 'test' && \
    bundle install --jobs 4 --retry 3

# Copiar o código da aplicação
COPY . .

# Criar diretórios necessários
RUN mkdir -p tmp/pids tmp/cache tmp/sockets log

# Expor a porta do Rails
EXPOSE 3005

# Comando padrão (pode ser sobrescrito no docker-compose)
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3005"]
