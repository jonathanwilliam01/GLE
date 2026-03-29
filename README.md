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

docker-compose up -d

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
