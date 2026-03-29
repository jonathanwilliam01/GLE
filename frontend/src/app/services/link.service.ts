import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

@Injectable({ providedIn: 'root' })
export class LinkService {
  private url = `${environment.apiUrl}/links`;

  constructor(private http: HttpClient) {}

  listar(idCategoria?: number): Observable<any[]> {
    let params = new HttpParams();
    if (idCategoria != null) {
      params = params.set('id_categoria', String(idCategoria));
    }
    return this.http.get<any[]>(this.url, { params });
  }
}
