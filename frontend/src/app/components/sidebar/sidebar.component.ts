import { BreakpointObserver, BreakpointState } from '@angular/cdk/layout';
import { AfterViewInit, Component, ElementRef, EventEmitter, inject, OnDestroy, OnInit, Output, Renderer2, ViewChild } from '@angular/core';
import { PanelMenu } from 'primeng/panelmenu';
import { Menu } from 'primeng/menu';
import { Subscription } from 'rxjs';
import { SidebarMenu } from './sidebar.menu';

@Component({
  selector: 'app-sidebar',
  templateUrl: './sidebar.component.html',
  styleUrls: ['./sidebar.component.scss'],
})
export class SidebarComponent implements OnInit, OnDestroy, AfterViewInit {
  @Output() collapseStatus = new EventEmitter<boolean>();
  collapsed = false;
  showLabel = true;
  clickedMenu: any;

  @ViewChild('subMenu') subMenu!: Menu;
  @ViewChild('panelMenu') panelMenu!: PanelMenu;
  @ViewChild('panelMenuContainer', { read: ElementRef }) panelMenuContainer!: ElementRef;

  private subs: Subscription[] = [];
  private unlistenFns: (() => void)[] = [];
  private breakpointObserver: BreakpointObserver = inject(BreakpointObserver);
  private renderer: Renderer2 = inject(Renderer2);
  public sidebarMenu: SidebarMenu = inject(SidebarMenu);

  ngOnInit() {
    this.sidebarMenu.init();

    this.subs.push(
      this.breakpointObserver
        .observe(['(min-width: 1200px)'])
        .subscribe((state: BreakpointState) => {
          this.collapsed = state.matches;
          this.toggleCollapse();
        })
    );
  }

  ngOnDestroy() {
    this.unlistenFns.forEach(fn => fn());
    this.subs.forEach((sub) => sub.unsubscribe());
  }

  ngAfterViewInit() {
    this.unlistenFns.forEach(fn => fn());
    this.unlistenFns = [];

    setTimeout(() => {
      const menuElement = this.panelMenuContainer.nativeElement;
      const headers = menuElement.querySelectorAll('.popup-submenu');
      headers.forEach((header: HTMLElement) => {
        const headerLink = header.querySelector('.p-panelmenu-header-link');
        if (headerLink) {
          this.unlistenFns.push(
            this.renderer.listen(headerLink, 'click', (event) => {
              if (this.collapsed) {
                event.preventDefault();
                event.stopPropagation();
                event.stopImmediatePropagation();
                const menuId = headerLink.id.replace('_header', '');
                this.subMenu.model = this.sidebarMenu.menus.find((menu) =>
                  menu.id === menuId
                )?.items || [];
                this.subMenu.toggle(event);
                this.clickedMenu = event.currentTarget;
                return;
              }
            })
          );
        }
      });
    }, 0);
  }

  onSubMenuShow($event: any) {
    setTimeout(() => {
      const menuElement = this.subMenu.containerViewChild?.nativeElement;
      if (!menuElement) return;

      this.renderer.addClass(menuElement, 'menu-on-right');
      const buttonRect = this.clickedMenu.getBoundingClientRect();

      const topPosition = buttonRect.top + window.scrollY;
      const leftPosition = buttonRect.right + window.scrollX + 1;

      this.renderer.setStyle(menuElement, 'position', 'absolute');
      this.renderer.setStyle(menuElement, 'top', `${topPosition}px`);
      this.renderer.setStyle(menuElement, 'left', `${leftPosition}px`);

      const menuRect = menuElement.getBoundingClientRect();
      if (menuRect.right > window.innerWidth) {
        this.renderer.setStyle(menuElement, 'left', 'auto');
        this.renderer.setStyle(menuElement, 'right', `${window.innerWidth - buttonRect.left + 5}px`);
      }
    });
  }

  onAreaChange(event: any) {
    this.sidebarMenu.filtrarArea(event.value);
  }

  toggleCollapse() {
    if (this.collapsed) {
      setTimeout(() => (this.showLabel = true), 350);
    } else {
      this.showLabel = false;
    }

    this.collapsed = !this.collapsed;
    this.collapseStatus.emit(this.collapsed);
    this.sidebarMenu.toggle(!this.collapsed);
  }
}
