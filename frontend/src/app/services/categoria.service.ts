import { inject, Injectable } from '@angular/core';
import { ApiService } from './api.service';
import { Categoria } from '@helpers/interfaces';

@Injectable({ providedIn: 'root' })
export class CategoriaService {
  private apiService: ApiService = inject(ApiService);

  listar(): Promise<Categoria[]> {
    return this.apiService.get('categorias');
  }

  buscarPorId(id: number): Promise<Categoria> {
    return this.apiService.get(`categorias/${id}`);
  }

  criar(dados: { nome: string; icon: string; areas: string[] }): Promise<any> {
    return this.apiService.post('categorias', dados);
  }

  atualizar(id: number, dados: { nome: string; icon: string; areas: string[] }): Promise<any> {
    return this.apiService.put(`categorias/${id}`, dados);
  }

  excluir(id: number): Promise<any> {
    return this.apiService.delete(`categorias/${id}`);
  }
}
