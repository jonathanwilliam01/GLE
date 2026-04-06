import { inject, Injectable, OnDestroy } from '@angular/core';
import { MenuItem, PrimeIcons } from 'primeng/api';
import { Router, NavigationEnd } from '@angular/router';
import { BehaviorSubject, Subscription, filter } from 'rxjs';
import { CategoriaService } from '@services/categoria.service';
import { AreaTecnicaService } from '@services/area-tecnica.service';
import { Categoria, AreaTecnica } from '@helpers/interfaces';
import { StorageService } from '@services/storage.service';
import { AdminService } from '@services/admin.service';

const AREA_COOKIE_KEY = 'gle_area_filtro';

@Injectable()
export class SidebarMenu implements OnDestroy {
  private router: Router = inject(Router);
  private categoriaService: CategoriaService = inject(CategoriaService);
  private areaTecnicaService: AreaTecnicaService = inject(AreaTecnicaService);
  private storageService: StorageService = inject(StorageService);
  private adminService: AdminService = inject(AdminService);

  public menus: MenuItem[] = [];
  public categorias: Categoria[] = [];
  public areaFiltro: string | null = null;
  public carregandoCategorias = true;

  public areasTecnicas: AreaTecnica[] = [];
  public areaOpcoesFiltro: { label: string; value: string | null }[] = [
    { label: 'Todas as áreas', value: null },
  ];

  private categoriaSelecionada$ = new BehaviorSubject<Categoria | null>(null);
  public categoriaSelecionada = this.categoriaSelecionada$.asObservable();
  private adminSub: Subscription;
  private routerSub: Subscription;

  constructor() {
    this.areaFiltro = this.storageService.getCookie(AREA_COOKIE_KEY) || null;
    this.buildMenus();
    this.adminSub = this.adminService.isAdmin$.subscribe(() => this.buildMenus());
    this.routerSub = this.router.events
      .pipe(filter((e) => e instanceof NavigationEnd))
      .subscribe(() => this.buildMenus());
  }

  public async init() {
    await Promise.all([this.carregarAreas(), this.carregarCategorias()]);
  }

  public async carregarAreas() {
    try {
      const areas = await this.areaTecnicaService.listar();
      // Popula areasTecnicas (usado no dialog de nova categoria) — inclui 'Todas'
      this.areasTecnicas = areas
        .map((a) => ({ label: a.nome, value: a.nome }));
      // Popula o filtro do dropdown (exclui 'Todas' pois já temos 'Todas as áreas')
      this.areaOpcoesFiltro = [
        { label: 'Todas as áreas', value: null },
        ...areas
          .filter((a) => a.nome !== 'Todas')
          .map((a) => ({ label: a.nome, value: a.nome })),
      ];
    } catch {
      // mantém os valores padrão
    }
  }

  public async carregarCategorias() {
    this.carregandoCategorias = true;
    try {
      this.categorias = await this.categoriaService.listar();
      this.buildMenus();
    } catch {
      this.categorias = [];
      this.buildMenus();
    } finally {
      this.carregandoCategorias = false;
    }
  }

  public selecionarCategoria(cat: Categoria | null) {
    this.categoriaSelecionada$.next(cat);
    this.buildMenus();
  }

  get categoriaSelecionadaAtual(): Categoria | null {
    return this.categoriaSelecionada$.value;
  }

  public filtrarArea(area: string | null) {
    this.areaFiltro = area;
    this.storageService.setCookie(AREA_COOKIE_KEY, area || '');
    this.selecionarCategoria(null);
    this.buildMenus();
  }

  get categoriasFiltradas(): Categoria[] {
    if (!this.areaFiltro) return this.categorias;
    return this.categorias.filter(
      (c) => c.areas.includes(this.areaFiltro!) || c.areas.includes('Todas')
    );
  }

  private buildMenus() {
    const sep = (): MenuItem => ({ separator: true, styleClass: 'separator' });
    const catAtual = this.categoriaSelecionada$.value;
    const emCadastros = this.router.url?.startsWith('/cadastros');

    const menuDashboard: MenuItem = {
      label: 'Visão Geral',
      icon: PrimeIcons.CHART_BAR,
      styleClass: !emCadastros && catAtual === null ? 'cat-selected' : undefined,
      command: () => {
        this.selecionarCategoria(null);
        this.router.navigate(['/dashboard']);
      },
    };

    const catMenus: MenuItem[] = this.categoriasFiltradas.map((cat) => ({
      label: cat.nome,
      icon: cat.icon || PrimeIcons.FOLDER,
      styleClass: !emCadastros && catAtual?.id === cat.id ? 'cat-selected' : undefined,
      command: () => {
        const nova = catAtual?.id === cat.id ? null : cat;
        this.selecionarCategoria(nova);
        this.router.navigate(['/dashboard']);
      },
    }));

    this.menus = [
      menuDashboard,
      sep(),
      ...catMenus,
      ...(this.adminService.isAdmin
        ? [
            sep(),
            {
              label: 'Cadastros',
              icon: PrimeIcons.COG,
              styleClass: emCadastros ? 'cat-selected' : undefined,
              command: () => {
                this.router.navigate(['/cadastros']);
              },
            } as MenuItem,
          ]
        : []),
    ];
  }

  public toggle(expanded: boolean) {
    this.menus.forEach((menu) => {
      if (!menu.separator) this.setTooltipOptions(menu, expanded);
    });
  }

  private setTooltipOptions(item: MenuItem, disabled: boolean) {
    item.tooltipOptions = { tooltipLabel: item.label, disabled };
  }

  ngOnDestroy() {
    this.adminSub?.unsubscribe();
    this.routerSub?.unsubscribe();
  }
}
