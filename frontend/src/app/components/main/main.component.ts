import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { MenuItem } from 'primeng/api';

@Component({
  selector: 'app-main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.scss']
})
export class MainComponent implements OnInit {
  sidebarVisible: boolean = true;
  darkTheme: boolean = false;
  
  menuItems: MenuItem[] = [];
  
  categorias = [
    { id: 1, nome: 'Documentação', icon: 'pi pi-book', count: 5 },
    { id: 2, nome: 'Ferramentas', icon: 'pi pi-wrench', count: 8 },
    { id: 3, nome: 'APIs Externas', icon: 'pi pi-cloud', count: 3 },
    { id: 4, nome: 'Repositórios', icon: 'pi pi-github', count: 12 },
    { id: 5, nome: 'Tutoriais', icon: 'pi pi-video', count: 6 },
    { id: 6, nome: 'Monitoramento', icon: 'pi pi-chart-line', count: 4 },
    { id: 7, nome: 'Segurança', icon: 'pi pi-shield', count: 7 }
  ];

  links = [
    {
      id: 1,
      titulo: 'Documentação PostgreSQL',
      url: 'https://www.postgresql.org/docs/',
      categoria: 'Documentação',
      area: 'Banco de Dados',
      estado: 'Ativo'
    },
    {
      id: 2,
      titulo: 'Ruby on Rails Guides',
      url: 'https://guides.rubyonrails.org/',
      categoria: 'Documentação',
      area: 'Backend',
      estado: 'Ativo'
    },
    {
      id: 3,
      titulo: 'Documentação Angular',
      url: 'https://angular.io/docs',
      categoria: 'Documentação',
      area: 'Frontend',
      estado: 'Ativo'
    },
    {
      id: 4,
      titulo: 'PrimeNG Components',
      url: 'https://primeng.org/',
      categoria: 'Ferramentas',
      area: 'Frontend',
      estado: 'Ativo'
    },
    {
      id: 5,
      titulo: 'Repositório GLE',
      url: 'https://github.com/embras/gle',
      categoria: 'Repositórios',
      area: 'Desenvolvimento',
      estado: 'Ativo'
    }
  ];

  categoriaSelecionada: any = null;

  constructor(private router: Router) {}

  ngOnInit(): void {
    this.initMenuItems();
  }

  initMenuItems(): void {
    this.menuItems = [
      {
        label: 'Início',
        icon: 'pi pi-home',
        command: () => this.navegarPara('inicio')
      },
      {
        label: 'Links',
        icon: 'pi pi-link',
        items: [
          {
            label: 'Todos os Links',
            icon: 'pi pi-list',
            command: () => this.navegarPara('links')
          },
          {
            label: 'Adicionar Link',
            icon: 'pi pi-plus',
            command: () => this.adicionarLink()
          }
        ]
      },
      {
        label: 'Categorias',
        icon: 'pi pi-folder',
        command: () => this.navegarPara('categorias')
      },
      {
        label: 'Auditoria',
        icon: 'pi pi-history',
        command: () => this.navegarPara('auditoria')
      },
      {
        label: 'Sair',
        icon: 'pi pi-sign-out',
        command: () => this.logout()
      }
    ];
  }

  toggleSidebar(): void {
    this.sidebarVisible = !this.sidebarVisible;
  }

  toggleTheme(): void {
    this.darkTheme = !this.darkTheme;
    document.body.classList.toggle('dark-theme');
  }

  selecionarCategoria(categoria: any): void {
    this.categoriaSelecionada = categoria;
  }

  navegarPara(rota: string): void {
    console.log('Navegando para:', rota);
  }

  adicionarLink(): void {
    console.log('Adicionar novo link');
  }

  editarLink(link: any): void {
    console.log('Editar link:', link);
  }

  excluirLink(link: any): void {
    console.log('Excluir link:', link);
  }

  acessarLink(link: any): void {
    window.open(link.url, '_blank');
  }

  logout(): void {
    this.router.navigate(['/login']);
  }
}
