import { Component, inject, OnDestroy, OnInit } from '@angular/core';
import { ActivatedRoute, NavigationEnd, Router } from '@angular/router';
import { MenuItem } from 'primeng/api';
import { filter } from 'rxjs/operators';
import { Subscription } from 'rxjs';
import { SidebarMenu } from '../sidebar/sidebar.menu';

@Component({
  selector: 'app-breadcrumbs',
  template: `
    <p-breadcrumb [model]="items" [home]="home" *ngIf="items.length > 0"></p-breadcrumb>
  `,
  styles: [`
    :host {
      display: block;
      margin-bottom: 1rem;
    }
    :host ::ng-deep .p-breadcrumb {
      border: none;
      background: transparent;
      padding: 0;
    }
  `]
})
export class BreadcrumbsComponent implements OnInit, OnDestroy {
  items: MenuItem[] = [];
  home: MenuItem = { icon: 'pi pi-home', routerLink: '/dashboard' };

  private router: Router = inject(Router);
  private activatedRoute: ActivatedRoute = inject(ActivatedRoute);
  private sidebarMenu: SidebarMenu = inject(SidebarMenu);
  private subs: Subscription[] = [];

  ngOnInit(): void {
    this.rebuild();

    this.subs.push(
      this.router.events
        .pipe(filter((event: any) => event instanceof NavigationEnd))
        .subscribe(() => this.rebuild())
    );

    this.subs.push(
      this.sidebarMenu.categoriaSelecionada.subscribe(() => this.rebuild())
    );
  }

  ngOnDestroy(): void {
    this.subs.forEach(s => s.unsubscribe());
  }

  private rebuild(): void {
    const base = this.createBreadcrumbs(this.activatedRoute.root);
    const isDashboard = this.router.url?.startsWith('/dashboard') || this.router.url === '/';
    const cat = this.sidebarMenu.categoriaSelecionadaAtual;

    if (isDashboard && cat) {
      this.items = [{ label: cat.nome }];
    } else {
      this.items = base;
    }
  }

  private createBreadcrumbs(route: ActivatedRoute, url = '', breadcrumbs: MenuItem[] = []): MenuItem[] {
    const children: ActivatedRoute[] = route.children;

    if (children.length === 0) {
      return breadcrumbs;
    }

    for (const child of children) {
      const routeURL: string = child.snapshot.url.map((segment: any) => segment.path).join('/');

      if (routeURL !== '') {
        url += `/${routeURL}`;
      }

      const label = child.snapshot.data['title'];

      if (label) {
        breadcrumbs.push({ label, routerLink: url });
      }

      return this.createBreadcrumbs(child, url, breadcrumbs);
    }

    return breadcrumbs;
  }
}
