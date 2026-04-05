import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { Router } from '@angular/router';
import { MessageService } from 'primeng/api';
import { Subscription } from 'rxjs';
import { CategoriaService } from '@services/categoria.service';
import { LinkService } from '@services/link.service';
import { AdminService } from '@services/admin.service';
import { Categoria, LinkItem, AreaTecnica } from '@helpers/interfaces';
import { SidebarMenu } from '@app/components/sidebar/sidebar.menu';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss'],
})
export class DashboardComponent implements OnInit, OnDestroy {
  private router: Router = inject(Router);
  private messageService: MessageService = inject(MessageService);
  private linkService: LinkService = inject(LinkService);
  private sidebarMenu: SidebarMenu = inject(SidebarMenu);
  public adminService: AdminService = inject(AdminService);

  readonly ITEMS_PER_PAGE = 8;
  readonly SECOES_COM_CATEGORIA = ['São Paulo', 'Rio de Janeiro', 'Minas Gerais'];

  showNovoLink = false;

  getTituloLink(link: LinkItem, secao: string): string {
    if (!this.categoriaSelecionada && this.SECOES_COM_CATEGORIA.includes(secao) && link.categoria_nome) {
      return `${link.categoria_nome} - ${link.titulo}`;
    }
    return link.titulo;
  }

  categoriaSelecionada: Categoria | null = null;
  private sub!: Subscription;

  pesquisa = '';
  paginas: { [secao: string]: number } = {};

  hoveredCard: string | null = null;
  carregandoLinks = false;
  links: LinkItem[] = [];

  viewMode: 'cards' | 'list' = 'cards';

  ngOnInit(): void {
    this.sub = this.sidebarMenu.categoriaSelecionada.subscribe((cat) => {
      this.categoriaSelecionada = cat;
      this.paginas = {};
      this.carregarLinks();
    });
  }

  ngOnDestroy(): void {
    this.sub?.unsubscribe();
  }

  async carregarLinks(): Promise<void> {
    this.carregandoLinks = true;
    try {
      const params: any = {};
      if (this.categoriaSelecionada) {
        params.id_categoria = this.categoriaSelecionada.id;
      }
      this.links = await this.linkService.listar(params);
    } catch {
      this.messageService.add({
        severity: 'error',
        summary: 'Erro',
        detail: 'Falha ao carregar links.',
      });
    } finally {
      this.carregandoLinks = false;
    }
  }

  get linksUnicos(): LinkItem[] {
    const seen = new Set<string>();
    return this.links.filter((l) => {
      const key = `${l.url}__${l.id_secao}__${l.id_categoria}`;
      if (seen.has(key)) return false;
      seen.add(key);
      return true;
    });
  }

  get secoesParaExibir(): string[] {
    const seen = new Map<number, string>();
    this.linksUnicos.forEach((l) => {
      if (l.secao && !seen.has(l.id_secao)) seen.set(l.id_secao, l.secao);
    });
    const todas = Array.from(seen.entries())
      .sort(([a], [b]) => a - b)
      .map(([, name]) => name);
    if (!this.pesquisa.trim()) return todas;
    return todas.filter((secao) => this.getLinksFiltrados(secao).length > 0);
  }

  getLinksFiltrados(secao: string): LinkItem[] {
    let filtered = this.linksUnicos.filter((l) => l.secao === secao);
    if (this.pesquisa.trim()) {
      const q = this.pesquisa.toLowerCase();
      filtered = filtered.filter(
        (l) =>
          l.titulo.toLowerCase().includes(q) ||
          (l.categoria_nome ?? '').toLowerCase().includes(q)
      );
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
    const pg = this.paginas[secao] ?? 0;
    if (pg > 0) this.paginas[secao] = pg - 1;
  }

  proximaPagina(secao: string): void {
    const pg = this.paginas[secao] ?? 0;
    if (pg < this.getTotalPaginas(secao) - 1) this.paginas[secao] = pg + 1;
  }

  pesquisar(): void {
    this.paginas = {};
  }

  copiarLink(link: LinkItem): void {
    navigator.clipboard.writeText(link.url);
    this.messageService.add({
      severity: 'info',
      summary: 'Copiado',
      detail: `Link de ${link.titulo} copiado!`,
      life: 2000,
    });
  }

  onLinkSalvo(): void {
    this.carregarLinks();
  }
}
