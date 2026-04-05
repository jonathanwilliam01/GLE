import { inject, Injectable } from '@angular/core';
import { ApiService } from './api.service';
import { Secao } from '@helpers/interfaces';

@Injectable({ providedIn: 'root' })
export class SecaoService {
  private apiService: ApiService = inject(ApiService);

  listar(): Promise<Secao[]> {
    return this.apiService.get('secoes');
  }

  criar(dados: { nome: string; sigla?: string }): Promise<Secao> {
    return this.apiService.post('secoes', dados);
  }

  atualizar(id: number, dados: { nome: string; sigla?: string }): Promise<Secao> {
    return this.apiService.put(`secoes/${id}`, dados);
  }

  excluir(id: number): Promise<any> {
    return this.apiService.delete(`secoes/${id}`);
  }
}
