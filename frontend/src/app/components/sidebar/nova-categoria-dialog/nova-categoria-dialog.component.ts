import { Component, EventEmitter, inject, Input, OnChanges, Output, SimpleChanges } from '@angular/core';
import { MessageService } from 'primeng/api';
import { CategoriaService } from '@services/categoria.service';
import { SidebarMenu } from '../sidebar.menu';

@Component({
  selector: 'app-nova-categoria-dialog',
  templateUrl: './nova-categoria-dialog.component.html',
  styleUrls: ['./nova-categoria-dialog.component.scss'],
})
export class NovaCategoriaDialogComponent implements OnChanges {
  @Input() visible = false;
  @Output() visibleChange = new EventEmitter<boolean>();

  nome = '';
  icon = 'pi pi-folder';
  areas: string[] = [];
  salvando = false;

  readonly iconesDisponiveis: { label: string; value: string }[] = [
    { label: 'Pasta',           value: 'pi pi-folder' },
    { label: 'Pasta aberta',    value: 'pi pi-folder-open' },
    { label: 'Globo',           value: 'pi pi-globe' },
    { label: 'Link',            value: 'pi pi-link' },
    { label: 'Computador',      value: 'pi pi-desktop' },
    { label: 'Engrenagem',      value: 'pi pi-cog' },
    { label: 'Engrenagens',     value: 'pi pi-sliders-h' },
    { label: 'Prédio',          value: 'pi pi-building' },
    { label: 'Usuário',         value: 'pi pi-user' },
    { label: 'Usuários',        value: 'pi pi-users' },
    { label: 'Documento',       value: 'pi pi-file' },
    { label: 'Documento PDF',   value: 'pi pi-file-pdf' },
    { label: 'Banco de Dados',  value: 'pi pi-database' },
    { label: 'Servidor',        value: 'pi pi-server' },
    { label: 'Escudo',          value: 'pi pi-shield' },
    { label: 'Chave',           value: 'pi pi-key' },
    { label: 'Crachá',          value: 'pi pi-id-card' },
    { label: 'Carta',           value: 'pi pi-envelope' },
    { label: 'Calendário',      value: 'pi pi-calendar' },
    { label: 'Gráfico de barras', value: 'pi pi-chart-bar' },
    { label: 'Gráfico de linha',  value: 'pi pi-chart-line' },
    { label: 'Mapa',            value: 'pi pi-map' },
    { label: 'Marcador de mapa','value': 'pi pi-map-marker' },
    { label: 'Casa',            value: 'pi pi-home' },
    { label: 'Ferramentas',     value: 'pi pi-wrench' },
    { label: 'Impressora',      value: 'pi pi-print' },
    { label: 'Câmera',          value: 'pi pi-camera' },
    { label: 'Imagem',          value: 'pi pi-image' },
    { label: 'Vídeo',           value: 'pi pi-video' },
    { label: 'Telefone',        value: 'pi pi-phone' },
    { label: 'Redes / Wi-Fi',   value: 'pi pi-wifi' },
    { label: 'Nuvem',           value: 'pi pi-cloud' },
    { label: 'Upload',          value: 'pi pi-upload' },
    { label: 'Download',        value: 'pi pi-download' },
    { label: 'Lupa',            value: 'pi pi-search' },
    { label: 'Informação',      value: 'pi pi-info-circle' },
    { label: 'Alerta',          value: 'pi pi-exclamation-circle' },
    { label: 'Estrela',         value: 'pi pi-star' },
    { label: 'Marcador',        value: 'pi pi-bookmark' },
    { label: 'Tag',             value: 'pi pi-tag' },
    { label: 'Grade',           value: 'pi pi-th-large' },
    { label: 'Lista',           value: 'pi pi-list' },
    { label: 'Tabela',          value: 'pi pi-table' },
    { label: 'Código',          value: 'pi pi-code' },
    { label: 'Terminal',        value: 'pi pi-desktop' },
    { label: 'Dinheiro',        value: 'pi pi-money-bill' },
    { label: 'Compras',         value: 'pi pi-shopping-cart' },
    { label: 'Caixa',           value: 'pi pi-inbox' },
    { label: 'Enviar',          value: 'pi pi-send' },
  ];

  getIconLabel(value: string): string {
    return this.iconesDisponiveis.find(i => i.value === value)?.label ?? value;
  }

  private messageService = inject(MessageService);
  private categoriaService = inject(CategoriaService);
  public sidebarMenu = inject(SidebarMenu);

  ngOnChanges(changes: SimpleChanges) {
    if (changes['visible']?.currentValue === true) {
      this.nome = '';
      this.icon = 'pi pi-folder';
      this.areas = [];
    }
  }

  cancelar() {
    this.visibleChange.emit(false);
  }

  async salvar() {
    if (!this.nome.trim()) {
      this.messageService.add({ severity: 'warn', summary: 'Atenção', detail: 'Informe o nome da categoria.' });
      return;
    }
    this.salvando = true;
    try {
      await this.categoriaService.criar({
        nome: this.nome.trim(),
        icon: this.icon.trim() || 'pi pi-folder',
        areas: this.areas,
      });
      this.messageService.add({ severity: 'success', summary: 'Sucesso', detail: 'Categoria criada.' });
      this.visibleChange.emit(false);
      await this.sidebarMenu.carregarCategorias();
    } catch {
      this.messageService.add({ severity: 'error', summary: 'Erro', detail: 'Falha ao criar categoria.' });
    } finally {
      this.salvando = false;
    }
  }
}
