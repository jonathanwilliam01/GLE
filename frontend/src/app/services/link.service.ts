import { inject, Injectable } from '@angular/core';
import { ApiService } from './api.service';
import { LinkItem } from '@helpers/interfaces';

@Injectable({ providedIn: 'root' })
export class LinkService {
  private apiService: ApiService = inject(ApiService);

  listar(params: any = {}): Promise<LinkItem[]> {
    return this.apiService.get('links', params);
  }

  buscarPorId(id: number): Promise<LinkItem> {
    return this.apiService.get(`links/${id}`);
  }

  criar(dados: any): Promise<any> {
    return this.apiService.post('links', dados);
  }

  atualizar(id: number, dados: any): Promise<any> {
    return this.apiService.put(`links/${id}`, dados);
  }

  excluir(id: number): Promise<any> {
    return this.apiService.delete(`links/${id}`);
  }
}
