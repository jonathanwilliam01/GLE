import { Component, Input } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-background',
  templateUrl: './background.component.html',
  styleUrls: ['./background.component.scss'],
})
export class BackgroundComponent {
  @Input() titulo = '';
  @Input() showReturn = true;

  constructor(private router: Router) {}

  returnToHome() {
    this.router.navigate(['/']);
  }
}
