export interface Conta {
  idLogin: number;
  nome: string;
  email: string;
  nivelAcesso: number;
  initials: string;
}

export interface Categoria {
  id: number;
  nome: string;
  icon: string;
  areas: string[];
  count: number;
}

export interface LinkItem {
  id: number;
  titulo: string;
  url: string;
  descricao?: string;
  id_secao: number;
  secao: string;
  id_categoria: number;
  categoria: string;
  categoria_nome?: string;
  area_tecnica?: string;
  qtd_cliques?: number;
  dt_exclusao?: string | null;
}

export interface Secao {
  id: number;
  nome: string;
  sigla?: string;
}

export interface AreaTecnica {
  label: string;
  value: string;
}
