# Docker - Instruções de Uso

## 🐳 Configuração Docker do Sistema GLE

Este documento contém as instruções para executar o sistema GLE usando Docker.

## 📋 Pré-requisitos

- Docker Engine 20.10+
- Docker Compose 2.0+
- Portas disponíveis: 3000 (Backend), 4200 (Frontend), 5432 (PostgreSQL)

## 🚀 Como Executar

### 1. Iniciar todos os serviços

```bash
docker-compose up -d
```

Este comando irá:
- Criar o container do PostgreSQL
- Executar o script de inicialização do banco (`db/init.sql`)
- Criar as tabelas: `categorias`, `links`, `auditoria`
- Inserir dados iniciais (seed)
- Iniciar o backend Rails na porta 3000
- Iniciar o frontend Angular na porta 4200

### 2. Verificar status dos containers

```bash
docker-compose ps
```

### 3. Ver logs dos serviços

```bash
# Logs de todos os serviços
docker-compose logs -f

# Logs de um serviço específico
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f db
```

### 4. Parar os serviços

```bash
docker-compose down
```

### 5. Parar e remover volumes (apaga dados do banco)

```bash
docker-compose down -v
```

## 🔧 Comandos Úteis

### Acessar o container do banco de dados

```bash
docker-compose exec db psql -U sysdba -d GLE
```

### Executar comandos Rails no backend

```bash
# Abrir console Rails
docker-compose exec backend rails console

# Executar migrations
docker-compose exec backend rails db:migrate

# Executar seeds
docker-compose exec backend rails db:seed

# Criar um novo controller
docker-compose exec backend rails generate controller Categories
```

### Executar comandos npm no frontend

```bash
# Instalar nova dependência
docker-compose exec frontend npm install <pacote>

# Gerar novo componente Angular
docker-compose exec frontend ng generate component components/links
```

### Rebuild dos containers

```bash
# Rebuild de todos os serviços
docker-compose up -d --build

# Rebuild de um serviço específico
docker-compose up -d --build backend
```

## 🌐 Acessando a Aplicação

Após iniciar os containers:

- **Frontend Angular**: http://localhost:4200
- **Backend Rails API**: http://localhost:3000
- **PostgreSQL**: localhost:5432

### Endpoints da API

- `GET /api/categorias` - Lista categorias
- `GET /api/links` - Lista links
- `GET /api/auditoria` - Lista registros de auditoria

## 📊 Estrutura do Banco de Dados

O banco de dados é criado automaticamente pelo script `db/init.sql` com:

### Tabelas:
- **categorias** - Organização dos links
- **links** - Links cadastrados
- **auditoria** - Histórico de alterações

### Recursos:
- Índices para otimização de consultas
- Triggers automáticos para auditoria
- Views para consultas facilitadas
- Dados iniciais (seed)

## 🔄 Reiniciar o Banco de Dados

Para reiniciar o banco com dados limpos:

```bash
# Parar e remover volumes
docker-compose down -v

# Subir novamente (irá recriar o banco)
docker-compose up -d
```

## 🛠️ Troubleshooting

### Porta já em uso

Se alguma porta estiver em uso, edite o arquivo `.env`:

```env
RAILS_PORT=3001
ANGULAR_PORT=4201
POSTGRES_PORT=5433
```

### Erro de conexão com o banco

Aguarde alguns segundos. O backend aguarda o banco estar saudável antes de conectar (healthcheck).

### Containers não iniciam

```bash
# Ver logs detalhados
docker-compose logs

# Limpar tudo e reconstruir
docker-compose down -v
docker-compose up -d --build
```

### Erro ao instalar gems/packages

```bash
# Rebuild das imagens
docker-compose build --no-cache backend frontend
docker-compose up -d
```

## 📝 Variáveis de Ambiente (.env)

As configurações estão centralizadas no arquivo `.env`:

```env
POSTGRES_DB=GLE
POSTGRES_USER=sysdba
POSTGRES_PASSWORD=wildfire
POSTGRES_HOST=db
POSTGRES_PORT=5432
RAILS_ENV=development
RAILS_PORT=3000
ANGULAR_PORT=4200
API_URL=http://localhost:3000/api
```

## 🔐 Segurança

**IMPORTANTE**: Altere as credenciais do banco em produção!

```env
POSTGRES_USER=seu_usuario
POSTGRES_PASSWORD=senha_forte_aqui
```

## 📦 Volumes Docker

O docker-compose cria volumes persistentes:

- `postgres_data` - Dados do PostgreSQL
- `rails_bundle` - Gems do Ruby

Para listar volumes:
```bash
docker volume ls | grep gle
```

## 🎯 Próximos Passos

1. Personalizar as configurações em `.env`
2. Desenvolver os controllers no backend
3. Implementar os componentes no frontend
4. Configurar autenticação de usuários
5. Adicionar testes automatizados

---

**GLE** - Gestão de Link Embras 🚀
