import { Component, HostBinding, HostListener, OnInit, OnDestroy, inject } from '@angular/core';
import { Router } from '@angular/router';
import { ConfirmationService, MessageService } from 'primeng/api';
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
  private confirmationService: ConfirmationService = inject(ConfirmationService);
  private linkService: LinkService = inject(LinkService);
  private sidebarMenu: SidebarMenu = inject(SidebarMenu);
  public adminService: AdminService = inject(AdminService);

  readonly SECOES_COM_CATEGORIA = ['São Paulo', 'Rio de Janeiro', 'Minas Gerais'];

  @HostBinding('class.host-has-category')
  get hostHasCategory(): boolean { return !!this.categoriaSelecionada; }

  @HostBinding('class.host-view-cards')
  get hostViewCards(): boolean { return this.viewMode === 'cards'; }

  get itemsPerPage(): number {
    if (!this.categoriaSelecionada) {
      // 7 itens × 40px = 280px + folga suficiente no card fixo de 490px
      return 7;
    }
    const h = window.innerHeight;
    // card body = vh - topbar(72) - footer(36) - main-padding(30) - breadcrumbs-margin(15)
    // - dashboard-header(53) - card-header(66) - card-footer(54) - body-padding(16)
    const rows = Math.floor((h - 342) / 40);
    return Math.max(6, Math.min(rows, 20));
  }

  @HostListener('window:resize')
  onResize(): void {}

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
  top5Links: LinkItem[] = [];

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
      } else {
        this.carregarTop5();
      }
      if (this.adminService.isAdmin) {
        params.incluir_excluidos = true;
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

  private async carregarTop5(): Promise<void> {
    try {
      this.top5Links = await this.linkService.top5();
    } catch {
      this.top5Links = [];
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

  private normalizar(texto: string): string {
    return texto
      .toLowerCase()
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '');
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
    const q = this.normalizar(this.pesquisa);
    // Mostra seção se o nome da seção bate OU se tem links filtrados
    return todas.filter(
      (secao) =>
        this.normalizar(secao).includes(q) ||
        this.getLinksFiltrados(secao).length > 0
    );
  }

  getLinksFiltrados(secao: string): LinkItem[] {
    let filtered = this.linksUnicos.filter((l) => l.secao === secao);
    if (this.pesquisa.trim()) {
      const q = this.normalizar(this.pesquisa);
      // Se a pesquisa bate com o nome da seção, retorna todos os links dela
      if (this.normalizar(secao).includes(q)) return this.sortComExcluidos(filtered);
      filtered = filtered.filter(
        (l) =>
          this.normalizar(l.titulo).includes(q) ||
          this.normalizar(l.categoria_nome ?? '').includes(q)
      );
    }
    return this.sortComExcluidos(filtered);
  }

  private sortComExcluidos(links: LinkItem[]): LinkItem[] {
    return [...links].sort((a, b) => {
      const aEx = !!a.dt_exclusao;
      const bEx = !!b.dt_exclusao;
      if (aEx === bEx) return 0;
      return aEx ? 1 : -1;
    });
  }

  getLinksAtivosNaSecao(secao: string): number {
    return this.getLinksFiltrados(secao).filter((l) => !l.dt_exclusao).length;
  }

  getLinksExcluidosNaSecao(secao: string): number {
    return this.getLinksFiltrados(secao).filter((l) => !!l.dt_exclusao).length;
  }

  getLinksPaginados(secao: string): LinkItem[] {
    const todos = this.getLinksFiltrados(secao);
    const pg = this.paginas[secao] ?? 0;
    return todos.slice(pg * this.itemsPerPage, (pg + 1) * this.itemsPerPage);
  }

  getTotalPaginas(secao: string): number {
    return Math.ceil(this.getLinksFiltrados(secao).length / this.itemsPerPage);
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
      detail: `Link ${link.categoria_nome ?? ''} de ${link.titulo} copiado!`,
      life: 2000,
    });
  }

  registrarClique(link: LinkItem): void {
    this.linkService.registrarClique(link.id).catch(() => {});
  }

  excluirLink(link: LinkItem): void {
    this.confirmationService.confirm({
      message: `Deseja excluir o link "${link.titulo}"?`,
      header: 'Confirmar Exclusão',
      icon: 'pi pi-exclamation-triangle',
      acceptLabel: 'Excluir',
      rejectLabel: 'Cancelar',
      rejectButtonStyleClass: 'p-button-text',
      acceptButtonStyleClass: 'p-button-danger',
      accept: async () => {
        try {
          await this.linkService.excluir(link.id);
          this.messageService.add({ severity: 'success', summary: 'Sucesso', detail: 'Link excluído.' });
          this.carregarLinks();
        } catch {
          this.messageService.add({ severity: 'error', summary: 'Erro', detail: 'Erro ao excluir o link.' });
        }
      },
    });
  }

  reativarLink(link: LinkItem): void {
    this.confirmationService.confirm({
      message: `Deseja reativar o link "${link.titulo}"?`,
      header: 'Confirmar Reativação',
      icon: 'pi pi-refresh',
      acceptLabel: 'Reativar',
      rejectLabel: 'Cancelar',
      rejectButtonStyleClass: 'p-button-text',
      acceptButtonStyleClass: 'p-button-success',
      accept: async () => {
        try {
          await this.linkService.reativar(link.id);
          this.messageService.add({ severity: 'success', summary: 'Sucesso', detail: 'Link reativado.' });
          this.carregarLinks();
        } catch {
          this.messageService.add({ severity: 'error', summary: 'Erro', detail: 'Erro ao reativar o link.' });
        }
      },
    });
  }

  onLinkSalvo(): void {
    this.carregarLinks();
  }
}
