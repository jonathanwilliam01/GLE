import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { MessageService } from 'primeng/api';
import { CategoriaService } from '../../services/categoria.service';
import { LinkService } from '../../services/link.service';

interface LinkItem {
  id: number;
  titulo: string;
  url: string;
  id_secao: number;
  secao: string;
  id_categoria: number;
}

interface AreaTecnica {
  label: string;
  value: string;
}

interface Categoria {
  id: number;
  nome: string;
  icon: string;
  areas: string[];
  count: number;
}

@Component({
  selector: 'app-main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.scss']
})
export class MainComponent implements OnInit {
  sidebarVisible: boolean = true;
  darkTheme: boolean = false;

  readonly ITEMS_PER_PAGE = 5;

  // Áreas técnicas
  areasTecnicas: AreaTecnica[] = [
    { label: 'Tributário', value: 'Tributario' },
    { label: 'Administrativo/RH', value: 'Administrativo/RH' },
    { label: 'Suprimentos', value: 'Suprimentos' },
    { label: 'Financeiro', value: 'Financeiro' },
    { label: 'Infraestrutura', value: 'Infraestrutura' },
    { label: 'Desenvolvimento', value: 'Desenvolvimento' }
  ];
  areaFiltro: string | null = null;

  // Categorias
  categorias: Categoria[] = [];
  carregandoCategorias: boolean = false;
  categoriaSelecionada: Categoria | null = null;

  // Pesquisa
  pesquisa: string = '';

  // Paginação por seção
  paginas: { [secao: string]: number } = {};

  // Modal nova categoria
  showCategoriaModal: boolean = false;
  salvandoCategoria: boolean = false;
  novaCategoria = { nome: '', icon: 'pi pi-folder', areas: [] as string[] };

  iconesPrimeNG = [
    { label: 'Pasta',          value: 'pi pi-folder' },
    { label: 'Monitor',        value: 'pi pi-desktop' },
    { label: 'Prédio',         value: 'pi pi-building' },
    { label: 'Usuário',        value: 'pi pi-user' },
    { label: 'Engrenagem',     value: 'pi pi-cog' },
    { label: 'Link',           value: 'pi pi-link' },
    { label: 'Arquivo',        value: 'pi pi-file' },
    { label: 'Globo',          value: 'pi pi-globe' },
    { label: 'Servidor',       value: 'pi pi-server' },
    { label: 'Banco de Dados', value: 'pi pi-database' },
    { label: 'Gráfico Barra',  value: 'pi pi-chart-bar' },
    { label: 'Gráfico Pizza',  value: 'pi pi-chart-pie' },
    { label: 'Mapa',           value: 'pi pi-sitemap' },
    { label: 'Etiqueta',       value: 'pi pi-tag' },
    { label: 'Escudo',         value: 'pi pi-shield' },
    { label: 'Código',         value: 'pi pi-code' },
    { label: 'Nuvem',          value: 'pi pi-cloud' },
    { label: 'Estrela',        value: 'pi pi-star' },
    { label: 'Favorito',       value: 'pi pi-bookmark' },
    { label: 'Casa',           value: 'pi pi-home' },
    { label: 'Cadeado',        value: 'pi pi-lock' },
    { label: 'Chave',          value: 'pi pi-key' },
    { label: 'Envelope',       value: 'pi pi-envelope' },
    { label: 'Calendário',     value: 'pi pi-calendar' },
    { label: 'Relógio',        value: 'pi pi-clock' },
    { label: 'Download',       value: 'pi pi-download' },
    { label: 'Upload',         value: 'pi pi-upload' },
    { label: 'Busca',          value: 'pi pi-search' },
    { label: 'Filtro',         value: 'pi pi-filter' },
    { label: 'Lista',          value: 'pi pi-list' },
    { label: 'Tabela',         value: 'pi pi-table' },
    { label: 'Grade',          value: 'pi pi-th-large' },
    { label: 'Informação',     value: 'pi pi-info-circle' },
    { label: 'Atenção',        value: 'pi pi-exclamation-triangle' },
    { label: 'Check',          value: 'pi pi-check-circle' },
    { label: 'Câmera',         value: 'pi pi-camera' },
    { label: 'Imagem',         value: 'pi pi-image' },
  ];

  // Modal editar link
  showEditLinkModal: boolean = false;
  linkEmEdicao: LinkItem = { id: 0, titulo: '', url: '', id_secao: 0, secao: '', id_categoria: 0 };

  // Modal novo link
  showNovoLinkModal: boolean = false;
  novoLink: LinkItem = { id: 0, titulo: '', url: '', id_secao: 0, secao: '', id_categoria: 0 };

  // Seções e links
  hoveredCard: string | null = null;
  carregandoLinks: boolean = false;
  links: LinkItem[] = [];

  constructor(
    private router: Router,
    private messageService: MessageService,
    private categoriaService: CategoriaService,
    private linkService: LinkService
  ) {}

  ngOnInit(): void {
    this.carregarCategorias();
    this.carregarLinks();
  }

  carregarCategorias(): void {
    this.carregandoCategorias = true;
    this.categoriaService.listar().subscribe({
      next: (cats: Categoria[]) => {
        this.categorias = cats;
        this.carregandoCategorias = false;
      },
      error: () => {
        this.carregandoCategorias = false;
        this.messageService.add({
          severity: 'error',
          summary: 'Erro',
          detail: 'Falha ao carregar categorias.'
        });
      }
    });
  }

  carregarLinks(): void {
    this.carregandoLinks = true;
    this.linkService.listar().subscribe({
      next: (lista: any[]) => {
        this.links = lista;
        this.carregandoLinks = false;
      },
      error: () => {
        this.carregandoLinks = false;
        this.messageService.add({
          severity: 'error',
          summary: 'Erro',
          detail: 'Falha ao carregar links.'
        });
      }
    });
  }

  get secoesParaExibir(): string[] {
    // Seções em ordem (id_secao) das que possuem links no filtro atual
    const linksAtivos = this.categoriaSelecionada
      ? this.links.filter(l => l.id_categoria === this.categoriaSelecionada!.id)
      : this.links;
    const seen = new Map<number, string>();
    linksAtivos.forEach(l => {
      if (l.secao && !seen.has(l.id_secao)) seen.set(l.id_secao, l.secao);
    });
    return Array.from(seen.entries()).sort(([a], [b]) => a - b).map(([, name]) => name);
  }

  get categoriasFiltradas(): Categoria[] {
    if (!this.areaFiltro) return this.categorias;
    return this.categorias.filter(c => c.areas.includes(this.areaFiltro!));
  }

  getLinksFiltrados(secao: string): LinkItem[] {
    let filtered = this.links.filter(l => l.secao === secao);
    if (this.categoriaSelecionada) {
      filtered = filtered.filter(l => l.id_categoria === this.categoriaSelecionada!.id);
    }
    if (this.pesquisa.trim()) {
      const q = this.pesquisa.toLowerCase();
      filtered = filtered.filter(l => l.titulo.toLowerCase().includes(q) || l.url.toLowerCase().includes(q));
    }
    return filtered;
  }

  getLinksPaginados(secao: string): LinkItem[] {
    const todos = this.getLinksFiltrados(secao);
    const pg = this.paginas[secao] ?? 0;
    return todos.slice(pg * this.ITEMS_PER_PAGE, (pg + 1) * this.ITEMS_PER_PAGE);
  }

  getTotalPaginas(secao: string): number {
    return Math.ceil(this.getLinksFiltrados(secao).length / this.ITEMS_PER_PAGE);
  }

  paginaAnterior(secao: string): void {
    if (this.paginas[secao] > 0) this.paginas[secao]--;
  }

  proximaPagina(secao: string): void {
    if (this.paginas[secao] < this.getTotalPaginas(secao) - 1) this.paginas[secao]++;
  }

  pesquisar(): void {
    this.paginas = {};
  }

  toggleSidebar(): void {
    this.sidebarVisible = !this.sidebarVisible;
  }

  toggleTheme(): void {
    this.darkTheme = !this.darkTheme;
    document.body.classList.toggle('dark-theme');
  }

  selecionarCategoria(categoria: Categoria): void {
    if (this.categoriaSelecionada?.id === categoria.id) {
      this.categoriaSelecionada = null;
    } else {
      this.categoriaSelecionada = categoria;
    }
    this.paginas = {};
  }

  getIconLabel(value: string): string {
    return this.iconesPrimeNG.find(i => i.value === value)?.label ?? value;
  }

  filtrarArea(): void {
    this.categoriaSelecionada = null;
  }

  // Modal nova categoria
  abrirModalCategoria(): void {
    this.novaCategoria = { nome: '', icon: 'pi pi-folder', areas: [] };
    this.showCategoriaModal = true;
  }

  salvarCategoria(): void {
    if (!this.novaCategoria.nome.trim()) return;
    this.salvandoCategoria = true;
    this.categoriaService.criar({
      nome: this.novaCategoria.nome,
      icon: this.novaCategoria.icon || 'pi pi-folder',
      areas: this.novaCategoria.areas
    }).subscribe({
      next: () => {
        this.showCategoriaModal = false;
        this.salvandoCategoria = false;
        this.messageService.add({
          severity: 'success',
          summary: 'Sucesso',
          detail: `Categoria "${this.novaCategoria.nome}" criada com sucesso!`
        });
        this.carregarCategorias();
      },
      error: () => {
        this.salvandoCategoria = false;
        this.messageService.add({
          severity: 'error',
          summary: 'Erro',
          detail: 'Falha ao criar categoria. Tente novamente.'
        });
      }
    });
  }

  // Copiar link
  copiarLink(link: LinkItem): void {
    navigator.clipboard.writeText(link.url);
    this.messageService.add({ severity: 'info', summary: 'Copiado', detail: `Link de ${link.titulo} copiado!`, life: 2000 });
  }

  // Modal editar link
  abrirEditarLink(link: LinkItem): void {
    this.linkEmEdicao = { ...link };
    this.showEditLinkModal = true;
  }

  salvarLink(): void {
    const idx = this.links.findIndex(l => l.id === this.linkEmEdicao.id);
    if (idx !== -1) {
      this.links[idx] = { ...this.linkEmEdicao };
    }
    this.showEditLinkModal = false;
    this.messageService.add({ severity: 'success', summary: 'Sucesso', detail: 'Link atualizado!' });
  }

  // Modal novo link
  abrirNovoLink(): void {
    this.novoLink = { id: 0, titulo: '', url: '', id_secao: 0, secao: '', id_categoria: 0 };
    this.showNovoLinkModal = true;
  }

  salvarNovoLink(): void {
    if (!this.novoLink.titulo.trim() || !this.novoLink.url.trim()) return;
    this.showNovoLinkModal = false;
    this.messageService.add({ severity: 'success', summary: 'Sucesso', detail: 'Link adicionado!' });
  }

  logout(): void {
    this.router.navigate(['/login']);
  }
}
