import { Component, inject, OnInit } from '@angular/core';
import { AuthService } from '@services/auth.service';

@Component({
  selector: 'app-topbar',
  templateUrl: './topbar.component.html',
})
export class TopbarComponent implements OnInit {
  private authService: AuthService = inject(AuthService);

  userName = '';
  userInitials = 'U';

  ngOnInit() {
    const user = this.authService.currentUser;
    if (user) {
      this.userName = user.nome || user.usuario || 'Usuário';
      this.userInitials = this.getInitials(this.userName);
    }
  }

  private getInitials(name: string): string {
    if (!name) return 'U';
    const parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
    }
    return name[0]?.toUpperCase() || 'U';
  }

  logout(): void {
    this.authService.logout();
  }
}
