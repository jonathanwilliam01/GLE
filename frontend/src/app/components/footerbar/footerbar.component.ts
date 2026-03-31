import { Component, OnDestroy, OnInit } from '@angular/core';
import { AuthService } from '@services/auth.service';

@Component({
  selector: 'app-footerbar',
  templateUrl: './footerbar.component.html',
})
export class FooterbarComponent implements OnInit, OnDestroy {
  public interval: any;
  public timeExp: string = '--:--:--';
  public version = 'v1.0.0';

  constructor(private authService: AuthService) {}

  ngOnInit() {
    this.startTimer();
  }

  ngOnDestroy() {
    clearInterval(this.interval);
  }

  startTimer() {
    this.interval = setInterval(() => {
      if (this.authService.loggedIn) {
        const expDate = this.authService.dataExpiracao;
        if (!expDate) return;

        const diffMs = expDate.getTime() - Date.now();
        if (diffMs > 0) {
          const h = Math.floor(diffMs / 3600000);
          const m = Math.floor((diffMs % 3600000) / 60000);
          const s = Math.floor((diffMs % 60000) / 1000);
          this.timeExp = `${String(h).padStart(2, '0')}:${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`;
        } else {
          this.authService.logout();
          clearInterval(this.interval);
        }
      } else {
        this.authService.logout();
        clearInterval(this.interval);
      }
    }, 1000);
  }
}
