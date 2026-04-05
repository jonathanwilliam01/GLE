import { inject, Injectable } from '@angular/core';
import { ApiService } from './api.service';
import { BehaviorSubject } from 'rxjs';

const ADMIN_KEY = 'gle_admin';

@Injectable({ providedIn: 'root' })
export class AdminService {
  private apiService: ApiService = inject(ApiService);
  private admin$ = new BehaviorSubject<boolean>(this.loadState());

  public isAdmin$ = this.admin$.asObservable();

  get isAdmin(): boolean {
    return this.admin$.value;
  }

  async login(user: string, senha: string): Promise<boolean> {
    try {
      await this.apiService.post('auth/login', { user, senha });
      sessionStorage.setItem(ADMIN_KEY, '1');
      this.admin$.next(true);
      return true;
    } catch {
      return false;
    }
  }

  logout(): void {
    sessionStorage.removeItem(ADMIN_KEY);
    this.admin$.next(false);
  }

  private loadState(): boolean {
    return sessionStorage.getItem(ADMIN_KEY) === '1';
  }
}
