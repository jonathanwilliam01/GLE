import { Component } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent {
  username: string = '';
  password: string = '';

  slides = [
    {
      title: 'BEM-VINDO AO GLE',
      subtitle: 'Gestão de Link Embras',
      description: 'Sistema de gerenciamento de links organizados por categorias para facilitar o acesso aos recursos da Embras.',
      image: 'assets/slide1.jpg'
    },
    {
      title: 'ORGANIZE SEUS LINKS',
      subtitle: 'Categorias e Áreas Técnicas',
      description: 'Organize seus links por categorias e áreas técnicas. Acesse rapidamente os recursos que você precisa.',
      image: 'assets/slide2.jpg'
    },
    {
      title: 'AUDITORIA COMPLETA',
      subtitle: 'Rastreabilidade Total',
      description: 'Todas as ações são registradas automaticamente. Histórico completo de alterações disponível.',
      image: 'assets/slide3.jpg'
    }
  ];

  constructor(private router: Router) {}

  onLogin(): void {
    // Por enquanto, apenas redireciona para a tela principal
    this.router.navigate(['/main']);
  }

  onForgotPassword(): void {
    alert('Funcionalidade de recuperação de senha em breve!');
  }
}
