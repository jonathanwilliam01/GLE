import { Component, EventEmitter, inject, Input, OnChanges, Output, SimpleChanges } from '@angular/core';
import { MessageService } from 'primeng/api';
import { LinkService } from '@services/link.service';
import { CategoriaService } from '@services/categoria.service';
import { SecaoService } from '@services/secao.service';
import { Categoria, LinkItem, Secao } from '@helpers/interfaces';

@Component({
  selector: 'app-novo-link-dialog',
  templateUrl: './novo-link-dialog.component.html',
  styleUrls: ['./novo-link-dialog.component.scss'],
})
export class NovoLinkDialogComponent implements OnChanges {
  @Input() visible = false;
  @Output() visibleChange = new EventEmitter<boolean>();
  @Output() linkSalvo = new EventEmitter<void>();
  @Input() linkParaEditar: LinkItem | null = null;

  titulo = '';
  url = '';
  id_secao: number | null = null;
  id_categoria: number | null = null;

  salvando = false;
  categorias: Categoria[] = [];
  secoes: Secao[] = [];

  private messageService = inject(MessageService);
  private linkService = inject(LinkService);
  private categoriaService = inject(CategoriaService);
  private secaoService = inject(SecaoService);

  ngOnChanges(changes: SimpleChanges) {
    if (changes['visible']?.currentValue === true) {
      if (this.linkParaEditar) {
        this.titulo = this.linkParaEditar.titulo;
        this.url = this.linkParaEditar.url;
        this.id_secao = this.linkParaEditar.id_secao ?? null;
        this.id_categoria = this.linkParaEditar.id_categoria ?? null;
      } else {
        this.titulo = '';
        this.url = '';
        this.id_secao = null;
        this.id_categoria = null;
      }
      this.carregarDados();
    }
  }

  async carregarDados() {
    try {
      const [cats, secs] = await Promise.all([
        this.categoriaService.listar(),
        this.secaoService.listar(),
      ]);
      this.categorias = cats;
      this.secoes = secs;
    } catch {
      this.messageService.add({ severity: 'error', summary: 'Erro', detail: 'Falha ao carregar dados.' });
    }
  }

  cancelar() {
    this.visibleChange.emit(false);
  }

  async salvar() {
    if (!this.titulo.trim() || !this.url.trim() || !this.id_secao || !this.id_categoria) {
      this.messageService.add({ severity: 'warn', summary: 'Atenção', detail: 'Preencha todos os campos obrigatórios.' });
      return;
    }
    this.salvando = true;
    try {
      if (this.linkParaEditar) {
        await this.linkService.atualizar(this.linkParaEditar.id, {
          titulo: this.titulo.trim(),
          link: this.url.trim(),
          id_secao: this.id_secao,
          id_categoria: this.id_categoria,
        });
        this.messageService.add({ severity: 'success', summary: 'Sucesso', detail: 'Link atualizado com sucesso.' });
      } else {
        await this.linkService.criar({
          titulo: this.titulo.trim(),
          link: this.url.trim(),
          id_secao: this.id_secao,
          id_categoria: this.id_categoria,
        });
        this.messageService.add({ severity: 'success', summary: 'Sucesso', detail: 'Link criado com sucesso.' });
      }
      this.visibleChange.emit(false);
      this.linkSalvo.emit();
    } catch {
      this.messageService.add({ severity: 'error', summary: 'Erro', detail: this.linkParaEditar ? 'Falha ao atualizar link.' : 'Falha ao criar link.' });
    } finally {
      this.salvando = false;
    }
  }
}
