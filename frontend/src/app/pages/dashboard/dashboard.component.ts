import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { Router } from '@angular/router';
import { MessageService } from 'primeng/api';
import { Subscription } from 'rxjs';
import { CategoriaService } from '@services/categoria.service';
import { LinkService } from '@services/link.service';
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

  readonly ITEMS_PER_PAGE = 5;

  categoriaSelecionada: Categoria | null = null;
  private sub!: Subscription;

  pesquisa = '';
  paginas: { [secao: string]: number } = {};

  hoveredCard: string | null = null;
  carregandoLinks = false;
  links: LinkItem[] = [];

  ngOnInit(): void {
    this.sub = this.sidebarMenu.categoriaSelecionada.subscribe((cat) => {
      this.categoriaSelecionada = cat;
      this.paginas = {};
      this.carregarLinks();
    });

    this.carregarLinks();
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

  get secoesParaExibir(): string[] {
    const seen = new Map<number, string>();
    this.links.forEach((l) => {
      if (l.secao && !seen.has(l.id_secao)) seen.set(l.id_secao, l.secao);
    });
    return Array.from(seen.entries())
      .sort(([a], [b]) => a - b)
      .map(([, name]) => name);
  }

  getLinksFiltrados(secao: string): LinkItem[] {
    let filtered = this.links.filter((l) => l.secao === secao);
    if (this.pesquisa.trim()) {
      const q = this.pesquisa.toLowerCase();
      filtered = filtered.filter(
        (l) => l.titulo.toLowerCase().includes(q) || l.url.toLowerCase().includes(q)
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
    if (this.paginas[secao] > 0) this.paginas[secao]--;
  }

  proximaPagina(secao: string): void {
    if (this.paginas[secao] < this.getTotalPaginas(secao) - 1) this.paginas[secao]++;
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
}
