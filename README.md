# GLE - Gestão de Link Embras

## 🎯 Objetivo

O **GLE (Gestão de Link Embras)** é um sistema moderno e intuitivo para gerenciamento centralizado de links e recursos web utilizados pela Embras. Desenvolvido para facilitar o acesso, organização e rastreamento de URLs importantes, o GLE permite que equipes organizem links por categorias, seções e áreas técnicas, com auditoria completa de todas as operações realizadas.

### Principais Benefícios
- ✅ **Organização Centralizada**: Todas as URLs em um único local
- ✅ **Acesso Rápido**: Localização fácil de links por categoria e seção
- ✅ **Controle de Admin**: Login seguro e operações exclusivas para administradores
- ✅ **Auditoria Completa**: Rastreamento de quem, quando e o quê foi alterado
- ✅ **Interface Moderna**: Design responsivo com temas claro/escuro

---

## 🔧 Stack Tecnológica

### Backend
- **Ruby on Rails 7** - Framework web para API REST
- **PostgreSQL 15** - Banco de dados relacional
- **Puma 6.6** - Servidor web
- **Rack/CORS** - Suporte a requisições cross-origin

### Frontend
- **Angular 17** - Framework TypeScript para aplicações web
- **PrimeNG 17** - Biblioteca de componentes UI
- **TypeScript 5** - Linguagem tipada para JavaScript
- **RxJS 7** - Programação reativa

### DevOps
- **Docker & Docker Compose** - Containerização e orquestração
- **Node.js 18+** - Runtime JavaScript

---

## 📋 Pré-requisitos

### Sistema
- Docker e Docker Compose instalados
- Terminal/Command Prompt
- Navegador moderno (Chrome, Firefox, Safari, Edge)

```

---

## 🚀 Instalação

### 1. Clonar o Repositório
```bash
git clone <url-repositorio>
cd geosiap-gle
```

### 2. Configurar Variáveis de Ambiente
```bash
cp .env.example .env
# Editar .env com suas credenciais
```

### 3. Subir os Containers
```bash
docker compose up -d
```

#### Serviços iniciados:
- **Backend**: `http://localhost:3006`
- **Frontend**: `http://localhost:4005`

### 4. Acessar a Aplicação
- URL: `http://localhost:4005`

---

## 📂 Estrutura do Projeto

```
geosiap-gle/
├── backend/                    # API Rails
│   ├── app/
│   │   ├── controllers/       # Endpoints da API
│   │   ├── models/            # Models (Link, Categoria, Seção, etc)
│   │   ├── serializers/       # Serialização de respostas JSON
│   │   └── services/          # Lógica de negócio
│   ├── config/
│   │   ├── database.yml       # Configurações do banco
│   │   └── routes.rb          # Rotas da API
│   ├── db/
│   │   ├── migrate/           # Migrações do banco
│   │   └── init.sql           # Script de inicialização
│   ├── Gemfile                # Dependências Ruby
│   └── Dockerfile             # Build do container backend
│
├── frontend/                   # Aplicação Angular
│   ├── src/
│   │   ├── app/
│   │   │   ├── components/    # Componentes reutilizáveis
│   │   │   ├── pages/         # Páginas principais
│   │   │   ├── services/      # Serviços (HTTP, Auth, etc)
│   │   │   ├── helpers/       # Utilitários e interfaces
│   │   │   └── app.module.ts  # Módulo raiz
│   │   ├── assets/            # Imagens e recursos estáticos
│   │   └── styles.scss        # Estilos globais
│   ├── package.json           # Dependências Node
│   ├── angular.json           # Configuração Angular
│   └── Dockerfile             # Build do container frontend
│
├── db/
│   └── init.sql               # Schema e dados iniciais
│
├── docker-compose.yml         # Orquestração dos serviços
├── .env                       # Variáveis de ambiente
└── README.md                  # Este arquivo
```

---

## 🎮 Como Funciona

### Fluxo de Dados

```
┌─────────────┐
│   Browser   │
│  (Angular)  │
└──────┬──────┘
       │ HTTP/HTTPS
       ↓
┌──────────────────────┐
│  Frontend (4005)     │
│  ├─ Dashboard        │
│  ├─ Sidebar          │
│  └─ Login Dialog     │
└──────┬───────────────┘
       │ REST API calls
       ↓
┌──────────────────────┐
│  Backend (3006)      │
│  ├─ /api/v1/links    │
│  ├─ /api/v1/categorias
│  ├─ /api/v1/secoes   │
│  └─ /api/v1/auth     │
└──────┬───────────────┘
       │ SQL queries
       ↓
┌──────────────────────┐
│  PostgreSQL (5434)   │
│  ├─ gle_links        │
│  ├─ gle_categorias   │
│  ├─ gle_secoes       │
│  └─ gle_auditoria    │
└──────────────────────┘
```

### Operações Principais

#### 1. **Listar Links**
- GET `/api/v1/links?id_categoria=1`
- Retorna array de links filtrados por categoria

#### 2. **Criar Link** (Admin)
- POST `/api/v1/links`
- Body: `{titulo, link, id_categoria, id_secao}`

#### 3. **Editar Link** (Admin)
- PATCH `/api/v1/links/:id`
- Body: `{titulo, link, id_categoria, id_secao}`

#### 4. **Excluir Link** (Admin - soft delete)
- DELETE `/api/v1/links/:id`
- Registra em `dt_exclusao` sem remover dados

#### 5. **Autenticação Admin**
- POST `/api/v1/auth/login`
- Body: `{user, senha}`
- Valida contra `USER_ADMIN` e `SENHA_ADMIN`

---

## 👥 Autenticação e Permissões

### Perfis de Acesso

| Ação | Anônimo | Admin |
|------|---------|-------|
| Visualizar links | ✅ | ✅ |
| Criar link | ❌ | ✅ |
| Editar link | ❌ | ✅ |
| Excluir link | ❌ | ✅ |
| Ver links excluídos | ❌ | ✅ |
| Reativar link | ❌ | ✅ |
| Acessar auditoria | ❌ | ✅ |

### Login Admin
1. Clique em **"Admin"** (canto superior direito)
2. Insira usuário e senha
3. Clique **"Entrar"** → Badge "Admin" aparece na topbar
4. Clique **"Sair"** para fazer logout

---

## 📊 Funcionalidades Principais

### 1. **Dashboard**
- Visualização de links por seção em **cards** ou **lista**
- Paginação automática (7 itens por página)
- Busca em tempo real por título ou categoria
- Badge indicando links excluídos (admin)

### 2. **Menu Lateral**
- Seleção de categorias
- Filtro por área técnica
- Contadores de links por categoria

### 3. **Operações Admin**
- Menu de 3 pontos por link
  - Editar
  - Excluir / Reativar
- Botão "Novo Link" para criar novos resgistros
- Dialog interativo com campos obrigatórios

### 4. **Temas**
- 🌙 **Escuro**: Reduz fadiga visual
- ☀️ **Claro**: Maior contraste
- Toggle via botão na topbar

---

## 🐛 Troubleshooting

### Erro: "Credenciais inválidas"
- Verifique se `USER_ADMIN` e `SENHA_ADMIN` no `.env` estão corretos
- Reinicie o backend: `docker compose restart backend`

### Erro: "Falha ao carregar links"
- Confirme que a `DATABASE_URL` aponta para um banco PostgreSQL válido
- Teste conexão: 
  ```bash
  docker compose exec backend psql -U sysdba -h 172.16.80.68 -p 5434 -d geosiap_projetos -c "SELECT * FROM gle_links LIMIT 1;"
  ```

### Erro: "Cannot find module"
- Limpe a cache de build: 
  ```bash
  docker compose down
  docker volume prune
  docker compose up -d
  ```

**Recursos do Docker:**
- ✅ Banco de dados PostgreSQL configurado automaticamente
- ✅ Tabelas criadas via script de inicialização
- ✅ Dados iniciais (seed) inseridos
- ✅ Backend e Frontend prontos para uso
- ✅ Não requer instalação de Ruby, Node.js ou PostgreSQL

## 🎨 Temas PrimeNG

### Tema Claro
```scss
@import "primeng/resources/themes/lara-light-blue/theme.css";
```

### Tema Escuro
```scss
@import "primeng/resources/themes/lara-dark-blue/theme.css";
```
---
**GLE** - Gestão simplificada e eficiente de links técnicos 🚀
