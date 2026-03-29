import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

export interface CategoriaPayload {
  nome: string;
  icon: string;
  areas: string[];
}

@Injectable({ providedIn: 'root' })
export class CategoriaService {
  private url = `${environment.apiUrl}/categorias`;

  constructor(private http: HttpClient) {}

  listar(): Observable<any[]> {
    return this.http.get<any[]>(this.url);
  }

  criar(dados: CategoriaPayload): Observable<any> {
    return this.http.post<any>(this.url, dados);
  }
}
