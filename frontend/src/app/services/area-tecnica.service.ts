import { inject, Injectable } from '@angular/core';
import { ApiService } from './api.service';

export interface AreaTecnicaDB {
  id: number;
  nome: string;
}

@Injectable({ providedIn: 'root' })
export class AreaTecnicaService {
  private apiService: ApiService = inject(ApiService);

  listar(): Promise<AreaTecnicaDB[]> {
    return this.apiService.get('areas_tecnicas');
  }
}
