import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class StorageService {

  setStorage(key: string, value: string): void {
    localStorage.setItem(key, value);
  }

  getStorage(key: string): string | null {
    return localStorage.getItem(key);
  }

  removeStorage(key: string): void {
    localStorage.removeItem(key);
  }

  clearAll(): void {
    localStorage.clear();
  }

  getCookie(key: string): string | null {
    const match = document.cookie.match(new RegExp('(?:^|; )' + key + '=([^;]*)'));
    return match ? decodeURIComponent(match[1]) : null;
  }
}
