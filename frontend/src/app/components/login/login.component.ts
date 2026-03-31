import { Component, OnInit } from '@angular/core';
import { AuthService } from '@services/auth.service';
import { environment } from '@env/environment';

@Component({
  selector: 'app-login',
  template: ''
})
export class LoginComponent implements OnInit {
  constructor(private authService: AuthService) {}

  ngOnInit(): void {
    if (this.authService.loggedIn) {
      window.location.href = '/';
      return;
    }
    const returnUrl = encodeURIComponent(window.location.origin);
    window.location.href = `${environment.loginBaseUrl}/login?returnUrl=${returnUrl}`;
  }
}
