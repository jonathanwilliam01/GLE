import { inject } from '@angular/core';
import { CanActivateFn } from '@angular/router';
import { AuthService } from '@services/auth.service';
import { environment } from '@env/environment';

export const AuthGuard: CanActivateFn = () => {
  const authService = inject(AuthService);

  if (authService.loggedIn) {
    return true;
  }

  const returnUrl = encodeURIComponent(window.location.href);
  window.location.href = `${environment.loginBaseUrl}/login?returnUrl=${returnUrl}`;
  return false;
};
