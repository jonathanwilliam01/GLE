# GLE - Gestão de Link Embras

## 📋 Descrição

Sistema de gerenciamento de links organizados por categorias, desenvolvido para facilitar o acesso e organização de recursos web da Embras. O GLE permite cadastrar, editar e excluir links de forma simples e dinâmica, com interface moderna e intuitiva.

## 🚀 Stack Tecnológica

### Backend
- **Ruby on Rails** - Framework web para desenvolvimento da API REST
- **PostgreSQL** - Banco de dados relacional

### Frontend
- **Angular** - Framework JavaScript para desenvolvimento da interface
- **PrimeNG** - Biblioteca de componentes UI para Angular

## 🗄️ Estrutura do Banco de Dados

### Tabela: `categorias`

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id_categoria` | INTEGER (PK) | Identificador único da categoria |
| `ds_categoria` | VARCHAR(255) | Descrição/nome da categoria |
| `area_tecnica` | VARCHAR(100) | Área técnica relacionada |

### Tabela: `links`

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id_link` | INTEGER (PK) | Identificador único do link |
| `link` | VARCHAR(500) | URL do link |
| `titulo` | VARCHAR(255) | Título descritivo do link |
| `id_categoria` | INTEGER (FK) | Referência à categoria |
| `estado` | VARCHAR(50) | Estado/status do link |
| `area_tecnica` | VARCHAR(100) | Área técnica relacionada |
| `dt_inclusao` | DATE | Data de Inclusão |
| `dt_exclusao` | DATE | Data de Exclusão |

### Tabela: `auditoria`

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id_auditoria` | INTEGER (PK) | Identificador único da auditoria |
| `id_link` | INTEGER (FK) | Referência ao link auditado |
| `id_usuario` | INTEGER | Identificador do usuário que realizou a ação |
| `acao` | VARCHAR(50) | Tipo de ação (INSERT, UPDATE, DELETE) |
| `dt_auditoria` | TIMESTAMP | Data e hora da ação |

### Relacionamentos
- `links.id_categoria` → `categorias.id_categoria` (muitos-para-um)
- `auditoria.id_link` → `links.id_link` (muitos-para-um)

## ✨ Funcionalidades

### 1. Navegação por Categorias
- Menu lateral exibindo todas as categorias cadastradas
- Filtro por área técnica
- Navegação intuitiva entre categorias

### 2. Gerenciamento de Links
- **Visualização**: Lista de links organizados por categoria no painel principal (direita)
- **Inserção**: Adicionar novos links com todos os campos necessários
- **Edição**: Modificar informações de links existentes
- **Exclusão**: Remover links do sistema

### 3. Interface do Usuário
- **Layout Responsivo**: Interface adaptável a diferentes tamanhos de tela
- **Menu Lateral**: Navegação por categorias (esquerda)
- **Painel Principal**: Exibição e gestão de links (direita)
- **Temas**: Alternância entre tema claro e escuro
- **Design Moderno**: Uso de componentes PrimeNG

### 4. Auditoria
- **Rastreamento Completo**: Registro automático de todas as ações (inserção, edição, exclusão)
- **Histórico Detalhado**: Visualização da ação executada
- **Identificação do Usuário**: Registro de qual usuário realizou cada ação
- **Consulta de Auditoria**: Filtros por link, usuário ou período

### 5. Temas
- ☀️ **Tema Claro**: Interface clara para ambientes bem iluminados
- 🌙 **Tema Escuro**: Interface escura para reduzir fadiga visual
- Toggle fácil para alternar entre temas

## 🛠️ Instalação e Configuração

### Pré-requisitos
- Ruby 3.x
- Rails 7.x
- Node.js 18.x+
- PostgreSQL 14+
- Angular CLI

### Backend (Ruby on Rails)

```bash
# Clonar o repositório
git clone <repository-url>
cd GLE/backend

# Instalar dependências
bundle install

# Configurar banco de dados
rails db:create
rails db:migrate
rails db:seed

# Iniciar servidor
rails server
```

### Frontend (Angular)

```bash
# Navegar para a pasta frontend
cd GLE/frontend

# Instalar dependências
npm install

# Instalar PrimeNG e dependências
npm install primeng primeicons
npm install primeflex

# Iniciar servidor de desenvolvimento
ng serve
```

### 🐳 Docker (Recomendado)

A forma mais rápida de executar o GLE é usando Docker:

```bash
# Opção 1: Usando o script de início rápido
./start.sh

# Opção 2: Usando Make
make install

# Opção 3: Usando Docker Compose diretamente
docker-compose up -d
```

**Recursos do Docker:**
- ✅ Banco de dados PostgreSQL configurado automaticamente
- ✅ Tabelas criadas via script de inicialização
- ✅ Dados iniciais (seed) inseridos
- ✅ Backend e Frontend prontos para uso
- ✅ Não requer instalação de Ruby, Node.js ou PostgreSQL

**Comandos úteis:**
```bash
make help           # Ver todos os comandos disponíveis
make up             # Iniciar containers
make down           # Parar containers
make logs           # Ver logs em tempo real
make db-shell       # Acessar PostgreSQL
make rails-console  # Acessar Rails console
```

Veja [DOCKER.md](DOCKER.md) para documentação completa.

## 📁 Estrutura do Projeto

```
GLE/
├── backend/                 # API Ruby on Rails
│   ├── app/
│   │   ├── controllers/     # Controllers da API
│   │   ├── models/          # Models (Link, Categoria, Auditoria)
│   │   └── serializers/     # Serializers JSON
│   ├── db/
│   │   ├── migrate/         # Migrations do banco
│   │   └── seeds.rb         # Dados iniciais
│   └── config/
│       ├── database.yml     # Configuração do PostgreSQL
│       └── routes.rb        # Rotas da API
│
└── frontend/                # Aplicação Angular
    ├── src/
    │   ├── app/
    │   │   ├── components/  # Componentes Angular
    │   │   │   ├── menu/
    │   │   │   ├── links/
    │   │   │   ├── categorias/
    │   │   │   └── auditoria/
    │   │   ├── services/    # Serviços HTTP
    │   │   ├── models/      # Interfaces TypeScript
    │   │   └── themes/      # Configuração de temas
    │   ├── assets/          # Recursos estáticos
    │   └── styles.scss      # Estilos globais
    └── angular.json
```

## 🔌 Endpoints da API

### Categorias

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/categorias` | Lista todas as categorias |
| GET | `/api/categorias/:id` | Busca categoria específica |
| POST | `/api/categorias` | Cria nova categoria |
| PUT | `/api/categorias/:id` | Atualiza categoria |
| DELETE | `/api/categorias/:id` | Remove categoria |

### Links

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/links` | Lista todos os links |
| GET | `/api/links/:id` | Busca link específico |
| GET | `/api/categorias/:id/links` | Lista links de uma categoria |
| POST | `/api/links` | Cria novo link |
| PUT | `/api/links/:id` | Atualiza link |
| DELETE | `/api/links/:id` | Remove link |

### Auditoria

| Método | Endpoint | Descrição |
|--------|----------|-----------||
| GET | `/api/auditoria` | Lista todos os registros de auditoria |
| GET | `/api/auditoria/:id` | Busca registro específico |
| GET | `/api/links/:id/auditoria` | Lista auditoria de um link específico |
| GET | `/api/auditoria/usuario/:id` | Lista auditoria por usuário |
## 🎯 Componentes PrimeNG Utilizados

- **p-menubar** - Menu superior
- **p-sidebar** - Menu lateral de categorias
- **p-card** - Cards para exibição de links
- **p-table** - Tabela de auditoria
- **p-button** - Botões de ação
- **p-dialog** - Modais para formulários
- **p-inputText** - Campos de entrada
- **p-dropdown** - Seleção de categorias
- **p-calendar** - Seleção de datas para filtros de auditoria
- **p-confirmDialog** - Confirmação de exclusão
- **p-toast** - Notificações de sucesso/erro

## 🎨 Temas PrimeNG

### Tema Claro
```scss
@import "primeng/resources/themes/lara-light-blue/theme.css";
```

### Tema Escuro
```scss
@import "primeng/resources/themes/lara-dark-blue/theme.css";
```

## 📝 Modelos de Dados (TypeScript)

```typescript
// Link Interface
interface Link {
  id_link: number;
  link: string;
  titulo: string;
  id_categoria: number;
  estado: string;
  area_tecnica: string;
  dt_inclusao: Date;
  dt_exclusao?: Date;
}

// Categoria Interface
interface Categoria {
  id_categoria: number;
  ds_categoria: string;
  area_tecnica: string;
}

// Auditoria Interface
interface Auditoria {
  id_auditoria: number;
  id_link: number;
  id_usuario: number;
  acao: 'INSERT' | 'UPDATE' | 'DELETE';
  conteudo_antes: string;
  conteudo_depois: string;
  dt_auditoria: Date;
}
```

## 🔐 Segurança

- Validação de dados no backend
- CORS configurado para aceitar requisições do frontend
- Proteção contra SQL Injection (ActiveRecord)
- Sanitização de inputs no frontend
- Auditoria completa de todas as operações CRUD
- Rastreabilidade de ações por usuário
- Autenticação/Autorização (a ser implementada)

## 📈 Melhorias Futuras

- [ ] Sistema de autenticação de usuários
- [ ] Permissões por usuário/grupo
- [ ] Busca avançada de links
- [ ] Exportação de links (CSV, PDF)
- [ ] Visualização gráfica do histórico de auditoria
- [ ] Tags para links
- [ ] Favoritos
- [ ] Estatísticas de acesso
- [ ] Compartilhamento de links
- [ ] Relatórios de auditoria personalizados
---
**GLE** - Gestão simplificada e eficiente de links técnicos 🚀
