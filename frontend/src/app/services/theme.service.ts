import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

const STORAGE_KEY = 'gle_dark_theme';

@Injectable({ providedIn: 'root' })
export class ThemeService {
  private _dark = new BehaviorSubject<boolean>(false);
  readonly dark$ = this._dark.asObservable();

  get isDark(): boolean {
    return this._dark.value;
  }

  constructor() {
    const saved = localStorage.getItem(STORAGE_KEY);
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
    const dark = saved !== null ? saved === 'true' : prefersDark;
    this.apply(dark);
  }

  toggle(): void {
    this.apply(!this._dark.value);
  }

  private apply(dark: boolean): void {
    this._dark.next(dark);
    document.body.classList.toggle('dark-theme', dark);
    localStorage.setItem(STORAGE_KEY, String(dark));
  }
}
