# Case — Plataforma de Investimentos (README)

## Visão geral

Este é um *case* para a vaga de Desenvolvedor(a) de Software (Júnior/Pleno).
Objetivo: implementar a entidade **Investimento** corretamente e integrar funcionalidades front-end mínimas no *dashboard* e na página de usuário.

Ambiente:

* **Ruby:** 3.2.2
* **Rails:** 8.0.3
* **PostgreSQL:** 16.10

O projeto já contém duas entidades básicas:

* `User` — representa o usuário da plataforma.
* `Offer` — representa uma oferta de investimento.

O candidato deverá:

1. Implementar a entidade **investimentos** seguindo o padrão do projeto.
2. Implementar no **Dashboard** inicial as informações dos investimentos.
3. No **show** de `User`, exibir um resumo dos investimentos do usuário.

---

## Requisitos principais (resumido)

1. Modelagem:

   * Validações: O valor do investimento deve ser maior que 0; impedir investimento em `offer` com status que não aceite aplicações (ex.: `closed`).
2. API / Controller: endpoints básicos para criar e visualizar investimentos.
3. Dashboard (página inicial):

   * Rota: `GET /` (ou `/dashboard`).
   * Mostrar **3 cards** (inicialmente já existem 2 — Users e Offers). O candidato deve **implementar o card de investimentos**.
   * Cada card mostra:

     * Um título (ex.: `Total de Usuários`, `Total de Ofertas`, `Total de Investimentos`).
     * Um número principal (ex.: `124`).
   * Ao clicar num card, o usuário deve ser levado ao respectivo index:

     * `Total de Usuários` → `/users`
     * `Total de Ofertas` → `/offers`
     * `Total de Investimentos`
   * O card de investimentos deve ser implementado de modo consistente com os demais (mesmo layout/estilo).
4. Página de show do `User`:

   * Rota já existente: `GET /users/:id` — manter comportamento.
   * Dentro da view de show, adicionar uma seção **Investimentos** com um resumo sumarizado dos investimentos do usuário:

     * `Total investido`.
     * `Número de investimentos`.
   * A seção deve ser responsiva e de fácil leitura — respeite o estilo do projeto (use os mesmos componentes/partials dos cards quando possível).
5. Tests:

   * Model tests para `Investment` (validações, associações).
   * Controller/request tests para criação de investimento.

---

### Dashboard

* **GET** `/` — renderiza view com 3 cards.
* Cada card deve ser um link para o index respectivo:

  * `/users`
  * `/offers`
  * Implementar para investimentos

### User show — seção de Investimentos

* Dentro de `GET /users/:id`, incluir uma área parecida com:

  ```
  Investimentos
  - Total investido: R$ 12.345,67
  - Quantidade: 7
  ```
---

## Tarefas obrigatórias para o candidato

1. Criar migration para investimentos.
2. Implementar o model de investimentos com associações e validações.
3. Implementar o controller de investimento com endpoints mínimos.
4. Implementar/atualizar `DashboardsController#index` e view para incluir o card de investimentos.
5. Atualizar `UsersController#show` para mostrar resumo de investimentos conforme descrito.
6. Escrever testes (unit, request, feature) cobrindo os pontos acima.
7. Atualizar `routes.rb` com as rotas necessárias.
8. Atualizar `db/seeds.rb` com dados exemplares que tornem o dashboard e os resumos visíveis.

## Tarefas bônus para o candidato

1. Implementar testes para os arquivos envolvendo investimentos
2. Implementar docker no projeto
3. Melhoria no visual do projeto

---

## Critérios de avaliação (atualizado)

* Implementação correta do modelo de investimento e integridade referencial.
* Dashboard com os três cards funcionando e links corretos.
* Resumo de investimentos no `User#show` com métricas corretas e legíveis.
* Tratamento adequado de erros (mensagens claras).
* Cobertura de testes que valide o backend.
* Qualidade do código e commits claros.


---

## Como rodar (lembrando)

1. Instalar Ruby 3.2.2 e Bundler.
2. Configurar PostgreSQL 16.10 e `config/database.yml`.
3. Rodar:

```bash
bin/rails db:create db:migrate db:seed
bin/rails server
```

4. Testes:

```bash
bundle exec rspec
```

---

## Observações finais

* Commits pequenos e descritivos ajudam na avaliação.
* Escreva um código limpo e compatível com o padrão do projeto.

Boa sorte — aguardo a sua solução!
