import { Component, inject, OnInit, ViewChild } from '@angular/core';
import { MenuItem } from 'primeng/api';
import { Menu } from 'primeng/menu';
import { ConfirmationService, MessageService } from 'primeng/api';
import { SecaoService } from '@services/secao.service';
import { CategoriaService } from '@services/categoria.service';
import { AdminService } from '@services/admin.service';
import { Secao, Categoria } from '@helpers/interfaces';
import { SidebarMenu } from '@app/components/sidebar/sidebar.menu';

@Component({
  selector: 'app-cadastros',
  templateUrl: './cadastros.component.html',
  styleUrls: ['./cadastros.component.scss'],
})
export class CadastrosComponent implements OnInit {
  private secaoService = inject(SecaoService);
  private categoriaService = inject(CategoriaService);
  private confirmationService = inject(ConfirmationService);
  private messageService = inject(MessageService);
  public sidebarMenu = inject(SidebarMenu);
  public adminService = inject(AdminService);

  secoes: Secao[] = [];
  categorias: Categoria[] = [];
  carregando = true;

  // Dialogs
  showDialogSecao = false;
  showDialogCategoria = false;
  secaoEditando: Secao | null = null;
  categoriaEditando: Categoria | null = null;

  // Form fields
  secaoNome = '';
  secaoSigla = '';
  categoriaNome = '';
  categoriaIcon = '';
  categoriaAreas: string[] = [];

  // Menu popup
  @ViewChild('menuSecao') menuSecao!: Menu;
  @ViewChild('menuCategoria') menuCategoria!: Menu;

  secaoSelecionada: Secao | null = null;
  categoriaSelecionada: Categoria | null = null;

  menuSecaoItems: MenuItem[] = [
    {
      label: 'Editar',
      icon: 'pi pi-pencil',
      command: () => this.editarSecao(),
    },
    {
      label: 'Excluir',
      icon: 'pi pi-trash',
      styleClass: 'menu-danger',
      command: () => this.confirmarExcluirSecao(),
    },
  ];

  menuCategoriaItems: MenuItem[] = [
    {
      label: 'Editar',
      icon: 'pi pi-pencil',
      command: () => this.editarCategoria(),
    },
    {
      label: 'Excluir',
      icon: 'pi pi-trash',
      styleClass: 'menu-danger',
      command: () => this.confirmarExcluirCategoria(),
    },
  ];

  iconesDisponiveis = [
    { label: 'Pasta', value: 'pi pi-folder' },
    { label: 'Globo', value: 'pi pi-globe' },
    { label: 'Estrela', value: 'pi pi-star' },
    { label: 'Coração', value: 'pi pi-heart' },
    { label: 'Casa', value: 'pi pi-home' },
    { label: 'Usuários', value: 'pi pi-users' },
    { label: 'Configuração', value: 'pi pi-cog' },
    { label: 'Gráfico', value: 'pi pi-chart-bar' },
    { label: 'Mapa', value: 'pi pi-map-marker' },
    { label: 'Livro', value: 'pi pi-book' },
    { label: 'Calendário', value: 'pi pi-calendar' },
    { label: 'Sino', value: 'pi pi-bell' },
    { label: 'Tag', value: 'pi pi-tag' },
    { label: 'Carteira', value: 'pi pi-wallet' },
    { label: 'Carrinho', value: 'pi pi-shopping-cart' },
    { label: 'Telefone', value: 'pi pi-phone' },
    { label: 'Envelope', value: 'pi pi-envelope' },
    { label: 'Câmera', value: 'pi pi-camera' },
    { label: 'Imagem', value: 'pi pi-image' },
    { label: 'Vídeo', value: 'pi pi-video' },
    { label: 'Cadeado', value: 'pi pi-lock' },
    { label: 'Escudo', value: 'pi pi-shield' },
    { label: 'Raio', value: 'pi pi-bolt' },
    { label: 'Nuvem', value: 'pi pi-cloud' },
    { label: 'Banco de dados', value: 'pi pi-database' },
    { label: 'Servidor', value: 'pi pi-server' },
    { label: 'Código', value: 'pi pi-code' },
    { label: 'Prédio', value: 'pi pi-building' },
    { label: 'Carro', value: 'pi pi-car' },
    { label: 'Avião', value: 'pi pi-send' },
    { label: 'Dinheiro', value: 'pi pi-money-bill' },
    { label: 'Lápis', value: 'pi pi-pencil' },
    { label: 'Bandeira', value: 'pi pi-flag' },
    { label: 'Lâmpada', value: 'pi pi-sun' },
    { label: 'Relógio', value: 'pi pi-clock' },
    { label: 'Download', value: 'pi pi-download' },
    { label: 'Upload', value: 'pi pi-upload' },
    { label: 'Link', value: 'pi pi-link' },
    { label: 'Arquivo', value: 'pi pi-file' },
    { label: 'Check', value: 'pi pi-check-circle' },
    { label: 'Alerta', value: 'pi pi-exclamation-triangle' },
    { label: 'Info', value: 'pi pi-info-circle' },
    { label: 'Documento', value: 'pi pi-file-edit' },
    { label: 'Comentário', value: 'pi pi-comment' },
    { label: 'Favorito', value: 'pi pi-bookmark' },
    { label: 'Impressora', value: 'pi pi-print' },
    { label: 'Filtro', value: 'pi pi-filter' },
    { label: 'Lista', value: 'pi pi-list' },
    { label: 'Paleta', value: 'pi pi-palette' },
    { label: 'ID', value: 'pi pi-id-card' },
  ];

  async ngOnInit() {
    await this.carregarDados();
  }

  async carregarDados() {
    this.carregando = true;
    try {
      const [secoes, categorias] = await Promise.all([
        this.secaoService.listar(),
        this.categoriaService.listar(),
      ]);
      this.secoes = secoes;
      this.categorias = categorias;
    } catch {
      this.messageService.add({ severity: 'error', summary: 'Erro', detail: 'Erro ao carregar dados.' });
    }
    this.carregando = false;
  }

  // ===================== SEÇÕES =====================

  abrirNovaSecao() {
    this.secaoEditando = null;
    this.secaoNome = '';
    this.secaoSigla = '';
    this.showDialogSecao = true;
  }

  editarSecao() {
    if (!this.secaoSelecionada) return;
    this.secaoEditando = this.secaoSelecionada;
    this.secaoNome = this.secaoSelecionada.nome;
    this.secaoSigla = this.secaoSelecionada.sigla || '';
    this.showDialogSecao = true;
  }

  async salvarSecao() {
    const dados = { nome: this.secaoNome.trim(), sigla: this.secaoSigla.trim() || undefined };
    try {
      if (this.secaoEditando) {
        await this.secaoService.atualizar(this.secaoEditando.id, dados);
        this.messageService.add({ severity: 'success', summary: 'Sucesso', detail: 'Seção atualizada.' });
      } else {
        await this.secaoService.criar(dados);
        this.messageService.add({ severity: 'success', summary: 'Sucesso', detail: 'Seção criada.' });
      }
      this.showDialogSecao = false;
      await this.carregarDados();
    } catch {
      this.messageService.add({ severity: 'error', summary: 'Erro', detail: 'Erro ao salvar seção.' });
    }
  }

  confirmarExcluirSecao() {
    if (!this.secaoSelecionada) return;
    this.confirmationService.confirm({
      message: `Deseja excluir a seção "${this.secaoSelecionada.nome}"?`,
      header: 'Confirmar Exclusão',
      icon: 'pi pi-exclamation-triangle',
      acceptLabel: 'Excluir',
      rejectLabel: 'Cancelar',
      accept: () => this.excluirSecao(),
    });
  }

  private async excluirSecao() {
    if (!this.secaoSelecionada) return;
    try {
      await this.secaoService.excluir(this.secaoSelecionada.id);
      this.messageService.add({ severity: 'success', summary: 'Sucesso', detail: 'Seção excluída.' });
      await this.carregarDados();
    } catch {
      this.messageService.add({ severity: 'error', summary: 'Erro', detail: 'Erro ao excluir seção.' });
    }
  }

  onMenuSecaoClick(event: Event, secao: Secao) {
    this.secaoSelecionada = secao;
    this.menuSecao.toggle(event);
  }

  // ===================== CATEGORIAS =====================

  abrirNovaCategoria() {
    this.categoriaEditando = null;
    this.categoriaNome = '';
    this.categoriaIcon = 'pi pi-folder';
    this.categoriaAreas = [];
    this.showDialogCategoria = true;
  }

  editarCategoria() {
    if (!this.categoriaSelecionada) return;
    this.categoriaEditando = this.categoriaSelecionada;
    this.categoriaNome = this.categoriaSelecionada.nome;
    this.categoriaIcon = this.categoriaSelecionada.icon || 'pi pi-folder';
    this.categoriaAreas = [...(this.categoriaSelecionada.areas || [])];
    this.showDialogCategoria = true;
  }

  async salvarCategoria() {
    const dados = {
      nome: this.categoriaNome.trim(),
      icon: this.categoriaIcon,
      areas: this.categoriaAreas,
    };
    try {
      if (this.categoriaEditando) {
        await this.categoriaService.atualizar(this.categoriaEditando.id, dados);
        this.messageService.add({ severity: 'success', summary: 'Sucesso', detail: 'Categoria atualizada.' });
      } else {
        await this.categoriaService.criar(dados);
        this.messageService.add({ severity: 'success', summary: 'Sucesso', detail: 'Categoria criada.' });
      }
      this.showDialogCategoria = false;
      await this.carregarDados();
      await this.sidebarMenu.carregarCategorias();
    } catch {
      this.messageService.add({ severity: 'error', summary: 'Erro', detail: 'Erro ao salvar categoria.' });
    }
  }

  confirmarExcluirCategoria() {
    if (!this.categoriaSelecionada) return;
    this.confirmationService.confirm({
      message: `Deseja excluir a categoria "${this.categoriaSelecionada.nome}"?`,
      header: 'Confirmar Exclusão',
      icon: 'pi pi-exclamation-triangle',
      acceptLabel: 'Excluir',
      rejectLabel: 'Cancelar',
      accept: () => this.excluirCategoria(),
    });
  }

  private async excluirCategoria() {
    if (!this.categoriaSelecionada) return;
    try {
      await this.categoriaService.excluir(this.categoriaSelecionada.id);
      this.messageService.add({ severity: 'success', summary: 'Sucesso', detail: 'Categoria excluída.' });
      await this.carregarDados();
      await this.sidebarMenu.carregarCategorias();
    } catch {
      this.messageService.add({ severity: 'error', summary: 'Erro', detail: 'Erro ao excluir categoria.' });
    }
  }

  onMenuCategoriaClick(event: Event, categoria: Categoria) {
    this.categoriaSelecionada = categoria;
    this.menuCategoria.toggle(event);
  }

  getIconLabel(value: string): string {
    return this.iconesDisponiveis.find((i) => i.value === value)?.label || value;
  }

  sortSecoes(event: any) {
    const { field, order } = event;
    this.secoes = [...this.secoes].sort((a: any, b: any) => {
      const v1 = (a[field] ?? '').toString().toLowerCase();
      const v2 = (b[field] ?? '').toString().toLowerCase();
      return v1.localeCompare(v2) * order;
    });
  }

  sortCategorias(event: any) {
    const { field, order } = event;
    this.categorias = [...this.categorias].sort((a: any, b: any) => {
      const v1 = field === 'count' ? (a[field] ?? 0) : (a[field] ?? '').toString().toLowerCase();
      const v2 = field === 'count' ? (b[field] ?? 0) : (b[field] ?? '').toString().toLowerCase();
      if (typeof v1 === 'number') return (v1 - v2) * order;
      return v1.localeCompare(v2) * order;
    });
  }
}
