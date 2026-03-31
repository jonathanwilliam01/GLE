import { Component, ElementRef, ViewChild, Renderer2, inject } from '@angular/core';

@Component({
  selector: 'app-layout',
  templateUrl: './layout.component.html',
  styleUrls: ['./layout.component.scss'],
})
export class LayoutComponent {
  @ViewChild('master') master!: ElementRef;

  public collapseStatus = false;

  private renderer: Renderer2 = inject(Renderer2);

  getCollapseStatus(event: boolean) {
    this.collapseStatus = event;
    const gridTemplateColumns = this.collapseStatus
      ? '72px auto'
      : '280px auto';
    if (this.master) {
      this.renderer.setStyle(
        this.master.nativeElement,
        'grid-template-columns',
        gridTemplateColumns
      );
    }
  }
}
