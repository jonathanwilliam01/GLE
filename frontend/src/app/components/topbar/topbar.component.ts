import { Component, inject } from '@angular/core';
import { AdminService } from '@services/admin.service';
import { ThemeService } from '@services/theme.service';

@Component({
  selector: 'app-topbar',
  templateUrl: './topbar.component.html',
  styleUrls: ['./topbar.component.scss'],
})
export class TopbarComponent {
  public adminService: AdminService = inject(AdminService);
  public themeService: ThemeService = inject(ThemeService);

  showLogin = false;
  user = '';
  senha = '';
  logging = false;
  loginError = false;

  async doLogin() {
    this.loginError = false;
    this.logging = true;
    const ok = await this.adminService.login(this.user, this.senha);
    this.logging = false;
    if (ok) {
      this.showLogin = false;
      this.user = '';
      this.senha = '';
    } else {
      this.loginError = true;
    }
  }
}
