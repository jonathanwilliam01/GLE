import { inject, Injectable } from '@angular/core';
import { MenuItem, PrimeIcons } from 'primeng/api';
import { Router } from '@angular/router';
import { BehaviorSubject } from 'rxjs';
import { CategoriaService } from '@services/categoria.service';
import { Categoria, AreaTecnica } from '@helpers/interfaces';
import { StorageService } from '@services/storage.service';

const AREA_COOKIE_KEY = 'gle_area_filtro';

@Injectable()
export class SidebarMenu {
  private router: Router = inject(Router);
  private categoriaService: CategoriaService = inject(CategoriaService);
  private storageService: StorageService = inject(StorageService);

  public menus: MenuItem[] = [];
  public categorias: Categoria[] = [];
  public areaFiltro: string | null = null;

  public areasTecnicas: AreaTecnica[] = [
    { label: 'Tributário', value: 'Tributário' },
    { label: 'E-Gov', value: 'E-Gov' },
    { label: 'Geosiap', value: 'Geosiap' },
    { label: 'Todas', value: 'Todas' },
  ];

  private categoriaSelecionada$ = new BehaviorSubject<Categoria | null>(null);
  public categoriaSelecionada = this.categoriaSelecionada$.asObservable();

  private menuDashboard: MenuItem = {
    label: 'Visão Geral',
    routerLink: '/dashboard',
    icon: PrimeIcons.CHART_BAR,
  };

  constructor() {
    this.areaFiltro = this.storageService.getCookie(AREA_COOKIE_KEY);
    this.buildMenus();
  }

  public async init() {
    await this.carregarCategorias();
  }

  public async carregarCategorias() {
    try {
      this.categorias = await this.categoriaService.listar();
      this.buildMenus();
    } catch {
      this.categorias = [];
      this.buildMenus();
    }
  }

  public selecionarCategoria(cat: Categoria | null) {
    this.categoriaSelecionada$.next(cat);
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
    return this.categorias.filter((c) => c.areas.includes(this.areaFiltro!));
  }

  private buildMenus() {
    const separator: MenuItem = { separator: true, styleClass: 'separator' };

    const catMenus: MenuItem[] = this.categoriasFiltradas.map((cat) => ({
      label: `${cat.nome} (${cat.count})`,
      icon: cat.icon || PrimeIcons.FOLDER,
      command: () => {
        const atual = this.categoriaSelecionada$.value;
        this.selecionarCategoria(atual?.id === cat.id ? null : cat);
      },
    }));

    this.menus = [
      this.menuDashboard,
      separator,
      ...catMenus,
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
}
