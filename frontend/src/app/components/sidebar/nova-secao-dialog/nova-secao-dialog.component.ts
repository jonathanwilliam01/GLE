import { Component, EventEmitter, inject, Input, OnChanges, Output, SimpleChanges } from '@angular/core';
import { MessageService } from 'primeng/api';
import { SecaoService } from '@services/secao.service';

@Component({
  selector: 'app-nova-secao-dialog',
  templateUrl: './nova-secao-dialog.component.html',
  styleUrls: ['./nova-secao-dialog.component.scss'],
})
export class NovaSecaoDialogComponent implements OnChanges {
  @Input() visible = false;
  @Output() visibleChange = new EventEmitter<boolean>();

  nome = '';
  sigla = '';
  salvando = false;

  private messageService = inject(MessageService);
  private secaoService = inject(SecaoService);

  ngOnChanges(changes: SimpleChanges) {
    if (changes['visible']?.currentValue === true) {
      this.nome = '';
      this.sigla = '';
    }
  }

  cancelar() {
    this.visibleChange.emit(false);
  }

  async salvar() {
    if (!this.nome.trim()) {
      this.messageService.add({ severity: 'warn', summary: 'Atenção', detail: 'Informe o nome da seção.' });
      return;
    }
    this.salvando = true;
    try {
      await this.secaoService.criar({
        nome: this.nome.trim(),
        sigla: this.sigla.trim() || undefined,
      });
      this.messageService.add({ severity: 'success', summary: 'Sucesso', detail: 'Seção criada com sucesso.' });
      this.visibleChange.emit(false);
    } catch {
      this.messageService.add({ severity: 'error', summary: 'Erro', detail: 'Falha ao criar seção.' });
    } finally {
      this.salvando = false;
    }
  }
}
