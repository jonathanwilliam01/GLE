import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from './auth.service';
import { environment } from '@env/environment';
import { firstValueFrom } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class ApiService {
  private httpClient: HttpClient = inject(HttpClient);
  private router: Router = inject(Router);
  private authService: AuthService = inject(AuthService);

  get(path: string, params: any = {}): Promise<any> {
    return firstValueFrom(
      this.httpClient.get(this.apiUrl(path), this.getOptions(params))
    )
      .then((response: any) => response)
      .catch((response: any) => this.errorResponse(response));
  }

  post(path: string, body: any = {}): Promise<any> {
    return firstValueFrom(
      this.httpClient.post(this.apiUrl(path), body, this.getOptions())
    )
      .then((response: any) => response)
      .catch((response: any) => this.errorResponse(response));
  }

  put(path: string, body: any = {}): Promise<any> {
    return firstValueFrom(
      this.httpClient.put(this.apiUrl(path), body, this.getOptions())
    )
      .then((response: any) => response)
      .catch((response: any) => this.errorResponse(response));
  }

  delete(path: string): Promise<any> {
    return firstValueFrom(
      this.httpClient.delete(this.apiUrl(path), this.getOptions())
    )
      .then((response: any) => response)
      .catch((response: any) => this.errorResponse(response));
  }

  private apiUrl(path: string): string {
    return `${environment.apiUrl}/${path}`;
  }

  private getOptions(params: any = {}) {
    let headers = new HttpHeaders({ 'Content-Type': 'application/json' });

    const token = this.authService.token;
    if (token) {
      headers = headers.set('Authorization', `Bearer ${token}`);
    }

    return {
      headers,
      params: new HttpParams({ fromObject: params }),
    };
  }

  private errorResponse(response: any) {
    switch (response.status) {
      case 401:
        this.authService.logout();
        break;
      case 422:
        throw response.error;
      default:
        throw response.error || { error: 'Erro interno do servidor' };
    }
  }
}
