import { inject, Injectable } from '@angular/core';
import jwt from '@app/helpers/jwt';
import { StorageService } from '@services/storage.service';
import { environment } from '@env/environment';

const TOKEN_KEY = 'geosiap';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  private storageService: StorageService = inject(StorageService);

  get loggedIn(): boolean {
    try {
      return !!this.currentUser;
    } catch {
      return false;
    }
  }

  get currentUser(): any {
    const token = this.storageService.getCookie(TOKEN_KEY);
    if (token) {
      return jwt.decode(token);
    }
    return null;
  }

  get token(): string {
    return this.storageService.getCookie(TOKEN_KEY) ?? '';
  }

  get dataExpiracao(): Date | null {
    const token = this.storageService.getCookie(TOKEN_KEY);
    if (token) {
      const decoded = jwt.decode(token);
      return decoded?.exp ? new Date(decoded.exp * 1000) : null;
    }
    return null;
  }

  logout(): void {
    window.location.href = `${environment.loginBaseUrl}/logout`;
  }
}
