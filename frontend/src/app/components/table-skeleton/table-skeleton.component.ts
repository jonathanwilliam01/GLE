import { Component, Input } from '@angular/core';

@Component({
  selector: 'table-skeleton',
  templateUrl: './table-skeleton.component.html',
})
export class TableSkeletonComponent {
  protected dummyRows = Array(10).fill(null);
  protected dummyCols = Array(1).fill(null);

  @Input() set rows(value: number) {
    this.dummyRows = Array(value).fill(null);
  }

  @Input() set cols(value: number) {
    this.dummyCols = Array(value).fill(null);
  }
}
