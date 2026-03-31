# Plano de Conversão e Padronização - GLE

## 📋 Visão Geral do Projeto

Este documento detalha o plano completo de conversão e padronização do **GLE (Gestão de Links Embras)** para adotar o padrão visual e arquitetural do **SST**, incluindo integração com autenticação externa via **geosiap-contas**.

---

## 🎯 Objetivos Principais

1. ✅ **Padronização Visual**: Adotar o padrão visual do SST (layout, cores, componentes, fontes)
2. ✅ **Autenticação Externa**: Integrar com geosiap-contas para login unificado
3. ✅ **Layout Responsivo**: Implementar sidebar, topbar e footer conforme SST
4. ✅ **Sistema de Temas**: Manter seleção de tema claro/escuro
5. ✅ **Preservação de Funcionalidades**: Manter CRUDs e exibição de links por cards/seções
6. ✅ **Estrutura de Banco**: Respeitar estrutura existente do PostgreSQL

---

## 🏗️ Arquitetura Atual vs. Nova Arquitetura

### **Arquitetura Atual (GLE)**
```
┌─────────────────────────────────────┐
│         Header (64px)                │
│  Logo | Pesquisa | Botões           │
├──────────┬──────────────────────────┤
│          │                          │
│ Sidebar  │    Main Content          │
│ (256px)  │    (Cards de Links)      │
│          │    por Seção             │
│ Toggle   │                          │
│          │                          │
└──────────┴──────────────────────────┘
```

### **Nova Arquitetura (Padrão SST)**
```
┌───────────┬──────────────────────────┐
│           │     Topbar (72px)        │
│  Sidebar  │  Estabelecimento | Menu  │
│  (280px)  ├──────────────────────────┤
│           │                          │
│  Logo     │    Main Container        │
│  Links    │    (Cards de Links)      │
│  Menu     │    por Seção             │
│  Categorias│                         │
│           │    Breadcrumbs           │
│  Toggle   │                          │
│  (72px)   │                          │
├───────────┼──────────────────────────┤
│  Footer   │      Footer (36px)       │
└───────────┴──────────────────────────┘
```

---

## 📦 Estrutura de Componentes (Angular)

### **Componentes a Criar/Migrar**

#### 1. **Layout Principal** (`layout.component`)
```typescript
// src/app/components/layout/layout.component.ts
- Estrutura grid master (sidebar | header | main | footer)
- Controle de colapso da sidebar
- Gerenciamento de estado de autenticação
```

#### 2. **Sidebar** (`sidebar.component`)
```typescript
// src/app/components/sidebar/sidebar.component.ts
- Logo do GLE
- Menu de categorias (PanelMenu)
- Filtro por área técnica
- Botão de toggle (expandir/colapsar)
- Footer com botões de ação
- Responsividade (280px expandido / 72px colapsado)
```

#### 3. **Topbar** (`topbar.component`)
```typescript
// src/app/components/topbar/topbar.component.ts
- Informações do usuário logado
- Menu de configurações
- Botão de logout
- Menu dropdown de opções
```

#### 4. **Main Container** (`main-container.component`)
```typescript
// src/app/components/main-container/main-container.component.ts
- Breadcrumbs
- Área de conteúdo (cards de links)
- Paginação por seção
- Filtros e buscas
```

#### 5. **Footer** (`footerbar.component`)
```typescript
// src/app/components/footerbar/footerbar.component.ts
- Informações de versão
- Links institucionais
```

#### 6. **Background** (`background.component`)
```typescript
// src/app/components/background/background.component.ts
- Background animado/estático
- Suporte a temas
```

---

## 🎨 Padronização Visual

### **1. Cores e Temas**

#### **Tema Claro (Light)**
```scss
:root {
  --primary-color: #3B82F6;           // Azul primário SST
  --primary-dark: #2563eb;
  --surface-0: #ffffff;               // Fundo principal
  --surface-50: #f8fafc;
  --surface-100: #f1f5f9;
  --surface-200: #e2e8f0;
  --surface-300: #cbd5e1;
  --surface-400: #94a3b8;
  --surface-500: #64748b;
  --surface-600: #475569;
  --surface-700: #334155;
  --surface-800: #1e293b;
  --surface-900: #0f172a;
  --text-color: #334155;
  --text-color-secondary: #64748b;
}
```

#### **Tema Escuro (Dark)**
```scss
body.dark-theme {
  --primary-color: #3B82F6;
  --surface-0: #0f172a;
  --surface-50: #1e293b;
  --surface-100: #334155;
  --surface-200: #475569;
  --surface-300: #64748b;
  --surface-400: #94a3b8;
  --surface-500: #cbd5e1;
  --surface-600: #e2e8f0;
  --surface-700: #f1f5f9;
  --surface-800: #f8fafc;
  --surface-900: #ffffff;
  --text-color: #f1f5f9;
  --text-color-secondary: #cbd5e1;
}
```

### **2. Tipografia**
```scss
// Fonte principal (mesma do SST)
font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, 
             "Helvetica Neue", Arial, sans-serif;

// Tamanhos
--font-size-xs: 0.75rem;    // 12px
--font-size-sm: 0.875rem;   // 14px
--font-size-base: 1rem;     // 16px
--font-size-lg: 1.125rem;   // 18px
--font-size-xl: 1.25rem;    // 20px
--font-size-2xl: 1.5rem;    // 24px
```

### **3. Grid Layout**
```scss
#master {
  height: 100vh;
  display: grid;
  grid-template-columns: 280px auto;
  grid-template-rows: 72px 1fr 36px;
  grid-template-areas:
    "sidebar header"
    "sidebar main-container"
    "sidebar footer";
  
  @media screen and (max-width: 1199px) {
    grid-template-columns: 72px auto;
  }
  
  min-width: 1024px;
  overflow-x: hidden;
}
```

### **4. Componentes PrimeNG**

#### **Botões**
```scss
.p-button {
  border-radius: 6px;
  font-weight: 500;
  padding: 0.625rem 1.25rem;
  transition: all 0.2s;
}

.p-button-primary {
  background: var(--primary-color);
  border-color: var(--primary-color);
}
```

#### **Cards de Links**
```scss
.link-card {
  background: var(--surface-0);
  border: 1px solid var(--surface-200);
  border-radius: 12px;
  padding: 1.25rem;
  transition: all 0.2s;
  cursor: pointer;

  &:hover {
    box-shadow: 0 4px 12px rgba(59, 130, 246, 0.15);
    border-color: var(--primary-color);
    transform: translateY(-2px);
  }
}
```

#### **Sidebar Menu (PanelMenu)**
```scss
.p-panelmenu {
  border: none;
  
  .p-panelmenu-header > a {
    background: var(--surface-0);
    border: none;
    color: var(--text-color);
    padding: 0.75rem 1rem;
    border-radius: 6px;
    
    &:hover {
      background: var(--surface-100);
      color: var(--primary-color);
    }
  }
  
  .p-menuitem-link-active {
    background: var(--primary-color) !important;
    color: white !important;
  }
}
```

---

## 🔐 Integração com geosiap-contas

### **1. Serviços de Autenticação**

#### **AuthService** (adaptar do geosiap-contas)
```typescript
// src/app/services/auth.service.ts
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { ApiService } from './api.service';
import jwt from '@helpers/jwt';

@Injectable({ providedIn: 'root' })
export class AuthService {
  
  constructor(
    private router: Router,
    private apiService: ApiService
  ) {}

  get loggedIn(): boolean {
    try {
      return !!this.currentUser;
    } catch {
      return false;
    }
  }

  get currentUser() {
    const token = localStorage.getItem('gle_token');
    return jwt.decode(token);
  }

  async login(usuario: string, senha: string): Promise<void> {
    const session = { usuario, senha };
    const data = await this.apiService.post('sessions', session);
    
    localStorage.setItem('gle_token', data.token);
    this.router.navigate(['/dashboard']);
  }

  async logout(): Promise<void> {
    await this.apiService.delete('sessions');
    localStorage.removeItem('gle_token');
    this.router.navigate(['/login']);
  }

  temPermissao(permissao: string): boolean {
    // Implementar lógica de permissões
    return true;
  }
}
```

#### **AuthGuard**
```typescript
// src/app/guards/auth.guard.ts
import { Injectable } from '@angular/core';
import { CanActivate, Router } from '@angular/router';
import { AuthService } from '@services/auth.service';

@Injectable({ providedIn: 'root' })
export class AuthGuard implements CanActivate {
  
  constructor(
    private authService: AuthService,
    private router: Router
  ) {}

  canActivate(): boolean {
    if (this.authService.loggedIn) {
      return true;
    }
    
    this.router.navigate(['/login']);
    return false;
  }
}
```

#### **API Service com Interceptor**
```typescript
// src/app/services/api.service.ts
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { environment } from '@env/environment';

@Injectable({ providedIn: 'root' })
export class ApiService {
  
  private baseUrl = environment.apiUrl;

  constructor(private http: HttpClient) {}

  private get headers(): HttpHeaders {
    const token = localStorage.getItem('gle_token');
    let headers = new HttpHeaders({ 'Content-Type': 'application/json' });
    
    if (token) {
      headers = headers.set('Authorization', `Bearer ${token}`);
    }
    
    return headers;
  }

  get(endpoint: string): Promise<any> {
    return this.http.get(`${this.baseUrl}/${endpoint}`, { 
      headers: this.headers 
    }).toPromise();
  }

  post(endpoint: string, data: any): Promise<any> {
    return this.http.post(`${this.baseUrl}/${endpoint}`, data, { 
      headers: this.headers 
    }).toPromise();
  }

  put(endpoint: string, data: any): Promise<any> {
    return this.http.put(`${this.baseUrl}/${endpoint}`, data, { 
      headers: this.headers 
    }).toPromise();
  }

  delete(endpoint: string): Promise<any> {
    return this.http.delete(`${this.baseUrl}/${endpoint}`, { 
      headers: this.headers 
    }).toPromise();
  }
}
```

### **2. Rotas Protegidas**

```typescript
// src/app/app-routing.module.ts
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AuthGuard } from '@guards/auth.guard';
import { LoginComponent } from '@components/login/login.component';
import { LayoutComponent } from '@components/layout/layout.component';
import { DashboardComponent } from '@pages/dashboard/dashboard.component';

const routes: Routes = [
  { 
    path: 'login', 
    component: LoginComponent 
  },
  {
    path: '',
    component: LayoutComponent,
    canActivate: [AuthGuard],
    children: [
      { 
        path: '', 
        redirectTo: 'dashboard', 
        pathMatch: 'full' 
      },
      { 
        path: 'dashboard', 
        component: DashboardComponent 
      },
      // Outras rotas protegidas
    ]
  },
  { 
    path: '**', 
    redirectTo: 'login' 
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
```

---

## 📊 Estrutura do Banco de Dados

### **Tabelas Existentes (Manter)**

#### **categorias**
```sql
CREATE TABLE categorias (
    id_categoria SERIAL PRIMARY KEY,
    ds_categoria VARCHAR(255) NOT NULL,
    area_tecnica VARCHAR(100),
    icone VARCHAR(255),
    dt_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dt_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### **secoes**
```sql
CREATE TABLE secoes (
    id_secao SERIAL PRIMARY KEY,
    ds_secao VARCHAR(50) NOT NULL,
    sigla_secao VARCHAR(10)
);
```

#### **links**
```sql
CREATE TABLE links (
    id_link SERIAL PRIMARY KEY,
    link VARCHAR(500) NOT NULL,
    ds_link VARCHAR(250),
    titulo VARCHAR(255) NOT NULL,
    id_categoria INTEGER NOT NULL REFERENCES categorias(id_categoria),
    id_secao INTEGER REFERENCES secoes(id_secao),
    area_tecnica VARCHAR(100),
    dt_inclusao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dt_exclusao TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE
);
```

#### **auditoria**
```sql
CREATE TABLE auditoria (
    id_auditoria SERIAL PRIMARY KEY,
    id_link INTEGER REFERENCES links(id_link),
    id_usuario INTEGER,
    acao VARCHAR(50) NOT NULL CHECK (acao IN ('INSERT', 'UPDATE', 'DELETE')),
    conteudo_antes TEXT,
    conteudo_depois TEXT,
    dt_auditoria TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### **Novas Tabelas (Adicionar)**

#### **usuarios** (Integração com geosiap-contas)
```sql
-- Tabela de cache/referência dos usuários
CREATE TABLE usuarios (
    id_usuario INTEGER PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    nivel_acesso INTEGER,
    ativo BOOLEAN DEFAULT TRUE,
    dt_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dt_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### **permissoes_usuario**
```sql
CREATE TABLE permissoes_usuario (
    id_permissao SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL REFERENCES usuarios(id_usuario),
    id_categoria INTEGER REFERENCES categorias(id_categoria),
    pode_ler BOOLEAN DEFAULT TRUE,
    pode_criar BOOLEAN DEFAULT FALSE,
    pode_editar BOOLEAN DEFAULT FALSE,
    pode_excluir BOOLEAN DEFAULT FALSE,
    dt_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 🔄 CRUDs e Funcionalidades

### **1. Dashboard/Página Principal**

#### **Estrutura de Cards por Seção**
```typescript
// Interface do Card de Link
interface LinkCard {
  id: number;
  titulo: string;
  url: string;
  descricao?: string;
  icone?: string;
  categoria: {
    id: number;
    nome: string;
    icone: string;
    cor?: string;
  };
  secao: {
    id: number;
    nome: string;
    sigla: string;
  };
  areaTecnica: string;
}
```

#### **Template de Card**
```html
<!-- Seção de Links -->
<div class="secao-container" *ngFor="let secao of secoes">
  <h2 class="secao-titulo">
    <i class="pi pi-map-marker"></i>
    {{ secao.nome }} 
    <span class="secao-sigla" *ngIf="secao.sigla">({{ secao.sigla }})</span>
  </h2>
  
  <div class="links-grid">
    <div class="link-card" *ngFor="let link of getLinksPorSecao(secao.id)">
      <div class="card-header">
        <i [class]="link.categoria.icone" [style.color]="link.categoria.cor"></i>
        <span class="categoria-tag">{{ link.categoria.nome }}</span>
      </div>
      
      <h3 class="link-titulo">{{ link.titulo }}</h3>
      <p class="link-descricao" *ngIf="link.descricao">
        {{ link.descricao }}
      </p>
      
      <div class="card-footer">
        <a [href]="link.url" target="_blank" class="btn-acessar">
          <i class="pi pi-external-link"></i>
          Acessar
        </a>
        
        <div class="card-actions" *ngIf="podeEditar">
          <button pButton icon="pi pi-pencil" 
                  class="p-button-text p-button-sm"
                  (click)="editarLink(link)"></button>
          <button pButton icon="pi pi-trash" 
                  class="p-button-text p-button-sm p-button-danger"
                  (click)="excluirLink(link)"></button>
        </div>
      </div>
    </div>
  </div>
  
  <!-- Paginação -->
  <p-paginator 
    *ngIf="totalLinksPorSecao(secao.id) > itemsPorPagina"
    [rows]="itemsPorPagina" 
    [totalRecords]="totalLinksPorSecao(secao.id)"
    (onPageChange)="onPageChange($event, secao.id)">
  </p-paginator>
</div>
```

### **2. CRUD de Categorias**

#### **Modal de Categoria**
```typescript
// Formulário de categoria
categoriaForm = this.fb.group({
  ds_categoria: ['', Validators.required],
  area_tecnica: [''],
  icone: ['pi pi-folder', Validators.required]
});

salvarCategoria(): void {
  if (this.categoriaForm.valid) {
    const categoria = this.categoriaForm.value;
    
    if (this.isEdicao) {
      this.categoriaService.atualizar(this.categoriaId, categoria)
        .subscribe(() => {
          this.messageService.add({
            severity: 'success',
            summary: 'Sucesso',
            detail: 'Categoria atualizada com sucesso'
          });
          this.fecharModal();
          this.recarregarCategorias();
        });
    } else {
      this.categoriaService.criar(categoria)
        .subscribe(() => {
          this.messageService.add({
            severity: 'success',
            summary: 'Sucesso',
            detail: 'Categoria criada com sucesso'
          });
          this.fecharModal();
          this.recarregarCategorias();
        });
    }
  }
}
```

### **3. CRUD de Links**

#### **Serviço de Links**
```typescript
// src/app/services/link.service.ts
@Injectable({ providedIn: 'root' })
export class LinkService {
  
  constructor(private apiService: ApiService) {}

  listar(filtros?: any): Promise<LinkCard[]> {
    const params = new URLSearchParams(filtros).toString();
    return this.apiService.get(`links?${params}`);
  }

  buscarPorId(id: number): Promise<LinkCard> {
    return this.apiService.get(`links/${id}`);
  }

  criar(link: Partial<LinkCard>): Promise<LinkCard> {
    return this.apiService.post('links', link);
  }

  atualizar(id: number, link: Partial<LinkCard>): Promise<LinkCard> {
    return this.apiService.put(`links/${id}`, link);
  }

  excluir(id: number): Promise<void> {
    return this.apiService.delete(`links/${id}`);
  }

  buscarPorCategoria(idCategoria: number): Promise<LinkCard[]> {
    return this.apiService.get(`links?id_categoria=${idCategoria}`);
  }

  buscarPorSecao(idSecao: number): Promise<LinkCard[]> {
    return this.apiService.get(`links?id_secao=${idSecao}`);
  }

  buscarPorAreaTecnica(area: string): Promise<LinkCard[]> {
    return this.apiService.get(`links?area_tecnica=${area}`);
  }
}
```

---

## 🎨 Componentes Reutilizáveis

### **1. Base Classes (do SST)**

#### **BaseList** (Lista genérica)
```typescript
// src/app/components/base-list/base-list.ts
export abstract class BaseList<T> implements OnInit {
  
  items: T[] = [];
  loading = false;
  totalRecords = 0;
  
  // Paginação
  first = 0;
  rows = 10;
  
  // Filtros
  filtros: any = {};
  
  abstract service: any;
  
  ngOnInit(): void {
    this.carregar();
  }
  
  carregar(): void {
    this.loading = true;
    this.service.listar({
      ...this.filtros,
      limit: this.rows,
      offset: this.first
    }).then((result: any) => {
      this.items = result.data;
      this.totalRecords = result.total;
      this.loading = false;
    });
  }
  
  onPageChange(event: any): void {
    this.first = event.first;
    this.rows = event.rows;
    this.carregar();
  }
  
  filtrar(filtros: any): void {
    this.filtros = filtros;
    this.first = 0;
    this.carregar();
  }
}
```

#### **BaseModal** (Modal genérico)
```typescript
// src/app/components/base-modal/base-modal.ts
export abstract class BaseModal<T> {
  
  visible = false;
  loading = false;
  isEdicao = false;
  
  abstract form: FormGroup;
  abstract service: any;
  
  show(item?: T): void {
    this.visible = true;
    this.isEdicao = !!item;
    
    if (item) {
      this.form.patchValue(item);
    } else {
      this.form.reset();
    }
  }
  
  hide(): void {
    this.visible = false;
    this.form.reset();
  }
  
  salvar(): void {
    if (!this.form.valid) {
      return;
    }
    
    this.loading = true;
    const data = this.form.value;
    
    const action = this.isEdicao 
      ? this.service.atualizar(data.id, data)
      : this.service.criar(data);
    
    action.then(() => {
      this.onSalvar();
      this.hide();
      this.loading = false;
    });
  }
  
  abstract onSalvar(): void;
}
```

### **2. Breadcrumbs**

```typescript
// src/app/components/breadcrumbs/breadcrumbs.component.ts
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, NavigationEnd, Router } from '@angular/router';
import { MenuItem } from 'primeng/api';
import { filter } from 'rxjs/operators';

@Component({
  selector: 'app-breadcrumbs',
  template: `
    <p-breadcrumb [model]="items" [home]="home"></p-breadcrumb>
  `
})
export class BreadcrumbsComponent implements OnInit {
  
  items: MenuItem[] = [];
  home: MenuItem = { icon: 'pi pi-home', routerLink: '/dashboard' };
  
  constructor(
    private router: Router,
    private activatedRoute: ActivatedRoute
  ) {}
  
  ngOnInit(): void {
    this.router.events
      .pipe(filter(event => event instanceof NavigationEnd))
      .subscribe(() => this.items = this.createBreadcrumbs(this.activatedRoute.root));
  }
  
  private createBreadcrumbs(route: ActivatedRoute, url = '', breadcrumbs: MenuItem[] = []): MenuItem[] {
    const children: ActivatedRoute[] = route.children;
    
    if (children.length === 0) {
      return breadcrumbs;
    }
    
    for (const child of children) {
      const routeURL: string = child.snapshot.url.map(segment => segment.path).join('/');
      
      if (routeURL !== '') {
        url += `/${routeURL}`;
      }
      
      const label = child.snapshot.data['breadcrumb'];
      
      if (label) {
        breadcrumbs.push({ label, routerLink: url });
      }
      
      return this.createBreadcrumbs(child, url, breadcrumbs);
    }
    
    return breadcrumbs;
  }
}
```

---

## 📱 Responsividade

### **Breakpoints**

```scss
// Breakpoints padrão SST
$breakpoint-xs: 576px;
$breakpoint-sm: 768px;
$breakpoint-md: 992px;
$breakpoint-lg: 1200px;
$breakpoint-xl: 1400px;

// Sidebar responsiva
aside.sidebar {
  width: 280px;
  
  @media (max-width: $breakpoint-lg) {
    width: 72px;
    
    .menu-label {
      display: none;
    }
  }
  
  @media (max-width: $breakpoint-md) {
    position: fixed;
    left: -280px;
    z-index: 1000;
    transition: left 0.3s;
    
    &.active {
      left: 0;
    }
  }
}

// Grid de cards responsivo
.links-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1.5rem;
  
  @media (max-width: $breakpoint-md) {
    grid-template-columns: 1fr;
  }
}
```

---

## 🚀 Plano de Implementação (Fases)

### **Fase 1: Preparação e Estrutura (1-2 semanas)**

#### ✅ **Semana 1: Setup e Estrutura Base**
- [ ] Atualizar dependências do Angular (versão compatível com SST)
- [ ] Instalar PrimeNG e dependências (mesma versão do SST)
- [ ] Criar estrutura de pastas seguindo padrão SST:
  ```
  src/app/
  ├── components/
  │   ├── layout/
  │   ├── sidebar/
  │   ├── topbar/
  │   ├── footerbar/
  │   ├── breadcrumbs/
  │   ├── background/
  │   ├── base-list/
  │   └── base-modal/
  ├── pages/
  │   ├── dashboard/
  │   ├── categorias/
  │   └── configuracoes/
  ├── services/
  │   ├── auth.service.ts
  │   ├── api.service.ts
  │   ├── link.service.ts
  │   └── categoria.service.ts
  ├── guards/
  │   └── auth.guard.ts
  ├── helpers/
  │   ├── interfaces.ts
  │   ├── jwt.ts
  │   └── permissoes.ts
  └── styles/
      ├── themes/
      │   ├── light.css
      │   └── dark.css
      └── index.scss
  ```

#### ✅ **Semana 2: Componentes Base**
- [ ] Criar LayoutComponent (grid master)
- [ ] Criar SidebarComponent (menu lateral)
- [ ] Criar TopbarComponent (barra superior)
- [ ] Criar FooterbarComponent
- [ ] Criar BackgroundComponent
- [ ] Configurar PrimeNG (temas, ícones, estilos)

---

### **Fase 2: Autenticação (1 semana)**

#### ✅ **Semana 3: Integração com geosiap-contas**
- [ ] Criar AuthService (baseado no geosiap-contas)
- [ ] Criar AuthGuard para rotas protegidas
- [ ] Implementar ApiService com interceptor JWT
- [ ] Criar LoginComponent (tela de login)
- [ ] Configurar rotas protegidas
- [ ] Testar fluxo completo de autenticação
- [ ] Implementar tratamento de erros e refresh token

---

### **Fase 3: Backend - API e Autenticação (1 semana)**

#### ✅ **Semana 4: API Rails**
- [ ] Criar endpoint de autenticação (sessions)
- [ ] Implementar JWT no backend Rails
- [ ] Criar middleware de autenticação
- [ ] Criar endpoints RESTful para:
  - [ ] Categorias (CRUD)
  - [ ] Links (CRUD)
  - [ ] Seções (CRUD)
  - [ ] Usuários (leitura)
  - [ ] Permissões
- [ ] Implementar validações e tratamento de erros
- [ ] Criar seeds de dados de teste
- [ ] Documentar API (Swagger/Postman)

---

### **Fase 4: Dashboard e Visualização (1-2 semanas)**

#### ✅ **Semana 5: Dashboard Principal**
- [ ] Criar DashboardComponent
- [ ] Implementar exibição de links por cards
- [ ] Organizar por seções
- [ ] Implementar paginação por seção
- [ ] Criar filtro por categoria (sidebar)
- [ ] Criar filtro por área técnica
- [ ] Implementar busca/pesquisa
- [ ] Criar BreadcrumbsComponent

#### ✅ **Semana 6: Cards e Interações**
- [ ] Estilizar cards de links (padrão SST)
- [ ] Implementar hover states
- [ ] Adicionar ações nos cards (editar, excluir)
- [ ] Implementar abertura de links (nova aba)
- [ ] Criar animações de transição
- [ ] Implementar loading states
- [ ] Adicionar tooltips

---

### **Fase 5: CRUDs Completos (2 semanas)**

#### ✅ **Semana 7: CRUD de Categorias**
- [ ] Criar página de gerenciamento de categorias
- [ ] Criar modal de categoria (criar/editar)
- [ ] Implementar formulário com validações
- [ ] Criar seletor de ícones (PrimeNG icons)
- [ ] Implementar listagem com filtros
- [ ] Adicionar confirmação de exclusão
- [ ] Implementar auditoria de alterações

#### ✅ **Semana 8: CRUD de Links**
- [ ] Criar modal de link (criar/editar)
- [ ] Implementar formulário completo:
  - [ ] Título
  - [ ] URL (com validação)
  - [ ] Descrição
  - [ ] Categoria (dropdown)
  - [ ] Seção (dropdown)
  - [ ] Área técnica (dropdown/multi-select)
- [ ] Implementar validações
- [ ] Adicionar preview de link
- [ ] Implementar exclusão lógica (soft delete)
- [ ] Criar modal de confirmação

---

### **Fase 6: Sistema de Temas (1 semana)**

#### ✅ **Semana 9: Temas Claro/Escuro**
- [ ] Implementar ThemeService
- [ ] Criar toggle de tema (sidebar footer)
- [ ] Aplicar variáveis CSS para temas
- [ ] Adaptar todos os componentes para suportar temas
- [ ] Persistir preferência no localStorage
- [ ] Implementar transições suaves
- [ ] Testar em todos os componentes
- [ ] Ajustar contrastes e acessibilidade

---

### **Fase 7: Funcionalidades Adicionais (1 semana)**

#### ✅ **Semana 10: Features Extras**
- [ ] Implementar sistema de permissões (por usuário/categoria)
- [ ] Criar página de configurações
- [ ] Implementar exportação de links (CSV/JSON)
- [ ] Criar relatórios de uso (mais acessados)
- [ ] Implementar favoritos por usuário
- [ ] Adicionar histórico de acessos (auditoria)
- [ ] Criar notificações (Toast/Messages)
- [ ] Implementar atalhos de teclado

---

### **Fase 8: Testes e Refinamento (1-2 semanas)**

#### ✅ **Semana 11: Testes**
- [ ] Testes unitários (componentes)
- [ ] Testes de serviços
- [ ] Testes de integração
- [ ] Testes E2E (Cypress/Protractor)
- [ ] Testes de responsividade
- [ ] Testes de acessibilidade (WCAG)
- [ ] Testes de performance

#### ✅ **Semana 12: Refinamento e Deploy**
- [ ] Corrigir bugs encontrados
- [ ] Otimizar performance (lazy loading, tree shaking)
- [ ] Ajustes finais de UX/UI
- [ ] Revisar código (code review)
- [ ] Documentação completa
- [ ] Deploy em ambiente de homologação
- [ ] Testes com usuários finais
- [ ] Deploy em produção

---

## 📋 Checklist de Migração

### **Frontend**
- [ ] Estrutura de componentes conforme SST
- [ ] Sidebar com PanelMenu
- [ ] Topbar com menu de usuário
- [ ] Footer padronizado
- [ ] Background component
- [ ] Breadcrumbs funcionando
- [ ] Sistema de temas (claro/escuro)
- [ ] Cards de links estilizados
- [ ] Formulários com validação
- [ ] Modais padronizados
- [ ] Loading states
- [ ] Mensagens de feedback (toast)
- [ ] Confirmações de ações
- [ ] Responsividade completa

### **Backend**
- [ ] API RESTful completa
- [ ] Autenticação JWT
- [ ] Middleware de autenticação
- [ ] Endpoints de categorias
- [ ] Endpoints de links
- [ ] Endpoints de seções
- [ ] Sistema de permissões
- [ ] Auditoria de alterações
- [ ] Validações de dados
- [ ] Tratamento de erros
- [ ] Seeds de dados

### **Autenticação**
- [ ] Integração com geosiap-contas
- [ ] Login funcional
- [ ] Logout funcional
- [ ] Proteção de rotas
- [ ] Refresh de token
- [ ] Tratamento de sessão expirada
- [ ] Níveis de acesso
- [ ] Permissões por categoria

### **Funcionalidades**
- [ ] Visualização de links por cards
- [ ] Organização por seções
- [ ] Filtro por categoria
- [ ] Filtro por área técnica
- [ ] Busca/pesquisa
- [ ] Paginação
- [ ] CRUD completo de categorias
- [ ] CRUD completo de links
- [ ] Exclusão lógica
- [ ] Auditoria de alterações

### **Qualidade**
- [ ] Código limpo e documentado
- [ ] Testes unitários
- [ ] Testes de integração
- [ ] Testes E2E
- [ ] Performance otimizada
- [ ] Acessibilidade (WCAG)
- [ ] SEO básico
- [ ] Documentação completa

---

## 🎯 Métricas de Sucesso

### **Técnicas**
- ✅ 100% das rotas protegidas por autenticação
- ✅ 90%+ de cobertura de testes
- ✅ Performance: Lighthouse score > 90
- ✅ Acessibilidade: WCAG AA compliant
- ✅ Tempo de carregamento < 3s
- ✅ Compatibilidade: Chrome, Firefox, Edge, Safari

### **Funcionais**
- ✅ Todos os CRUDs funcionando
- ✅ Sistema de temas operacional
- ✅ Filtros e buscas precisos
- ✅ Paginação eficiente
- ✅ Auditoria completa
- ✅ Permissões aplicadas corretamente

### **UX/UI**
- ✅ Interface consistente com SST
- ✅ Responsivo em todos os dispositivos
- ✅ Animações suaves
- ✅ Feedback visual adequado
- ✅ Navegação intuitiva
- ✅ Tempos de resposta aceitáveis

---

## 🛠️ Tecnologias e Dependências

### **Frontend**
```json
{
  "dependencies": {
    "@angular/animations": "^14.x",
    "@angular/common": "^14.x",
    "@angular/core": "^14.x",
    "@angular/forms": "^14.x",
    "@angular/platform-browser": "^14.x",
    "@angular/router": "^14.x",
    "primeng": "^14.x",
    "primeicons": "^6.x",
    "primeflex": "^3.x",
    "rxjs": "^7.x",
    "jsonwebtoken": "^9.x"
  }
}
```

### **Backend**
```ruby
# Gemfile
gem 'rails', '~> 7.0'
gem 'pg', '~> 1.4'
gem 'puma', '~> 5.0'
gem 'jwt', '~> 2.7'
gem 'bcrypt', '~> 3.1.7'
gem 'rack-cors'
```

---

## 📚 Documentação de Referência

### **Componentes SST a Estudar**
1. `/sst/frontend/src/app/components/layout/` - Layout principal
2. `/sst/frontend/src/app/components/sidebar/` - Sidebar e menu
3. `/sst/frontend/src/app/components/topbar/` - Topbar
4. `/sst/frontend/src/app/components/base-list/` - Lista base
5. `/sst/frontend/src/app/components/base-modal/` - Modal base
6. `/sst/frontend/src/styles/` - Estilos globais

### **Autenticação geosiap-contas**
1. `/geosiap-contas/frontend/src/app/services/auth.service.ts`
2. `/geosiap-contas/frontend/src/app/services/api.service.ts`
3. `/geosiap-contas/frontend/src/app/guards/auth.guard.ts`

### **Estrutura GLE Atual**
1. `/GLE/db/init.sql` - Estrutura do banco
2. `/GLE/frontend/src/app/components/main/` - Componente principal
3. `/GLE/frontend/src/styles.scss` - Estilos atuais

---

## 🎨 Mockups e Wireframes

### **Layout Final Esperado**

```
┌─────────────────────────────────────────────────────────────┐
│  🏢 GLE                    👤 Usuário ▾  ⚙️ Config  🚪 Sair  │ 72px
├────────────┬────────────────────────────────────────────────┤
│            │  🏠 Dashboard > Links por Categoria             │
│  📁 Categ. │                                                 │
│            │  ╔════════════════════════════════════════╗     │
│  ├─ Global │  ║  📍 São Paulo (SP)                    ║     │
│  │  Badge:8 │  ╠════════════════════════════════════════╣     │
│  ├─ IssOnl │  ║  ┌──────┐  ┌──────┐  ┌──────┐         ║     │
│  │  Badge:12│  ║  │ 🌐   │  │ 🖥️   │  │ 📱   │         ║     │
│  ├─ E-Gov  │  ║  │ Link1│  │ Link2│  │ Link3│         ║     │
│  │  Badge:5 │  ║  │      │  │      │  │      │         ║     │
│  └─ ...    │  ║  └──────┘  └──────┘  └──────┘         ║     │
│            │  ╚════════════════════════════════════════╝     │
│  🎨 Tema   │                                                 │
│  ☀️ Claro  │  ╔════════════════════════════════════════╗     │
│  🌙 Escuro │  ║  📍 Rio de Janeiro (RJ)               ║     │
│            │  ╠════════════════════════════════════════╣     │
│  ➕ Nova   │  ║  [Cards de links...]                   ║     │
│  Categoria │  ╚════════════════════════════════════════╝     │
│            │                                                 │
└────────────┴─────────────────────────────────────────────────┤
│  v1.0.0 - GLE Embras                                         │ 36px
└──────────────────────────────────────────────────────────────┘
```

---

## 📞 Contatos e Suporte

- **Desenvolvedor Frontend**: [Nome]
- **Desenvolvedor Backend**: [Nome]
- **DBA**: [Nome]
- **Repositório**: `/home/embras/Fontes/GLE`

---

## 📝 Notas Adicionais

### **Pontos de Atenção**
1. ⚠️ Manter compatibilidade com dados existentes no banco
2. ⚠️ Migração gradual (manter versão antiga até validação completa)
3. ⚠️ Backup completo antes de qualquer alteração no banco
4. ⚠️ Testes extensivos de autenticação
5. ⚠️ Validação de permissões em todas as operações

### **Melhorias Futuras (Pós-MVP)**
- 🚀 PWA (Progressive Web App)
- 🚀 Offline support
- 🚀 Notificações push
- 🚀 Integração com outros sistemas Geosiap
- 🚀 Dashboard de analytics
- 🚀 Sistema de favoritos compartilhados
- 🚀 Tags e categorização avançada
- 🚀 Busca por similaridade (AI)

---

**Documento criado em**: 31/03/2026  
**Versão**: 1.0  
**Status**: 📋 Planejamento
