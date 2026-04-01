import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';

// PrimeNG Modules
import { ButtonModule } from 'primeng/button';
import { RippleModule } from 'primeng/ripple';
import { InputTextModule } from 'primeng/inputtext';
import { CardModule } from 'primeng/card';
import { MenubarModule } from 'primeng/menubar';
import { SidebarModule } from 'primeng/sidebar';
import { PanelMenuModule } from 'primeng/panelmenu';
import { ToastModule } from 'primeng/toast';
import { TableModule } from 'primeng/table';
import { DialogModule } from 'primeng/dialog';
import { DropdownModule } from 'primeng/dropdown';
import { ConfirmDialogModule } from 'primeng/confirmdialog';
import { MultiSelectModule } from 'primeng/multiselect';
import { TooltipModule } from 'primeng/tooltip';
import { InputTextareaModule } from 'primeng/inputtextarea';
import { BreadcrumbModule } from 'primeng/breadcrumb';
import { MenuModule } from 'primeng/menu';

// Serviços PrimeNG
import { MessageService } from 'primeng/api';
import { ConfirmationService } from 'primeng/api';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';

// Components

import { MainComponent } from './components/main/main.component';
import { LayoutComponent } from './components/layout/layout.component';
import { SidebarComponent } from './components/sidebar/sidebar.component';
import { TopbarComponent } from './components/topbar/topbar.component';
import { FooterbarComponent } from './components/footerbar/footerbar.component';
import { BackgroundComponent } from './components/background/background.component';
import { BreadcrumbsComponent } from './components/breadcrumbs/breadcrumbs.component';
import { DashboardComponent } from './pages/dashboard/dashboard.component';

// Services
import { SidebarMenu } from './components/sidebar/sidebar.menu';

@NgModule({
  declarations: [
    AppComponent,
    MainComponent,
    LayoutComponent,
    SidebarComponent,
    TopbarComponent,
    FooterbarComponent,
    BackgroundComponent,
    BreadcrumbsComponent,
    DashboardComponent,
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
    AppRoutingModule,
    // PrimeNG
    ButtonModule,
    RippleModule,
    InputTextModule,
    CardModule,
    MenubarModule,
    SidebarModule,
    PanelMenuModule,
    ToastModule,
    TableModule,
    DialogModule,
    DropdownModule,
    ConfirmDialogModule,
    MultiSelectModule,
    TooltipModule,
    InputTextareaModule,
    BreadcrumbModule,
    MenuModule,
  ],
  providers: [
    MessageService,
    ConfirmationService,
    SidebarMenu,
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
