# 💰 Plataforma de Investimentos

Sistema de gerenciamento de investimentos desenvolvido em Ruby on Rails, permitindo cadastro de usuários, ofertas de captação (fundraises) e investimentos.

## 📋 Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Tecnologias](#tecnologias)
- [Funcionalidades](#funcionalidades)
- [Pré-requisitos](#pré-requisitos)
- [Instalação e Configuração](#instalação-e-configuração)
  - [Usando Docker (Recomendado)](#usando-docker-recomendado)
  - [Instalação Local](#instalação-local)
- [Como Usar](#como-usar)
- [Executando os Testes](#executando-os-testes)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Modelo de Dados](#modelo-de-dados)
- [Capturas de Tela](#capturas-de-tela)

---

## 🎯 Sobre o Projeto

Este projeto foi desenvolvido como case técnico para vaga de Desenvolvedor Ruby on Rails (Júnior/Pleno). O sistema implementa:

- **CRUD completo** para Usuários, Ofertas (Fundraises) e Investimentos
- **Dashboard** com estatísticas e gráficos
- **Validações** de negócio (não permitir investimento em oferta fechada)
- **Interface moderna** com Tailwind CSS
- **Testes automatizados** com RSpec
- **Containerização** com Docker

---

## 🚀 Tecnologias

| Tecnologia | Versão | Descrição |
|------------|--------|-----------|
| Ruby | 3.2.2 | Linguagem de programação |
| Rails | 8.0.3 | Framework web |
| PostgreSQL | 16 | Banco de dados |
| Tailwind CSS | 4.0 | Framework CSS |
| Chartkick | 5.0 | Biblioteca de gráficos |
| RSpec | 6.1 | Framework de testes |
| Ransack | 4.4 | Busca de registros |
| Docker | - | Containerização |
| Slim | - | Template engine |

---

## ✨ Funcionalidades

### Dashboard
- 📊 **4 cards estatísticos**: Total de usuários, ofertas, investimentos e valor total investido
- 📈 **Gráfico de barras**: Top 10 investidores
- 🔗 **Links rápidos**: Acesso às últimas entidades criadas

### Usuários
- ✅ CRUD completo de usuários
- 📋 Listagem com busca
- 💼 Página de perfil mostrando investimentos realizados
- 💰 Resumo: total investido e quantidade de investimentos
- 🔍 Busca e filtro: Implementado com Ransack, permitindo pesquisar por nome ou email
- ↕️ Ordenação clicável: Ao clicar nos nomes das colunas da tabela, é possível ordenar os registros por nome, email e/ou data de criação.

### Ofertas (Fundraises)
- ✅ CRUD completo de ofertas
- 🏷️ Status: Aberta/Fechada
- 📅 Datas de início e término
- 💵 Meta de captação
- 📊 Progresso de arrecadação
- 🔍 Busca e filtro: Implementado com Ransack, permitindo pesquisar por título ou descrição
- ↕️ Ordenação clicável: Ao clicar nos nomes das colunas da tabela, é possível ordenar os registros por título, meta, status, data de início e/ou data de término.

### Investimentos
- ✅ CRUD completo
- 🚫 Validação: não permite investir em oferta fechada
- 💸 Validação: valor deve ser maior que zero
- 🔗 Relacionamento entre usuário e oferta
- 🔍 Busca e filtro: Implementado com Ransack, permitindo pesquisar por nome do usuário ou oferta
- ↕️ Ordenação clicável: Ao clicar nos nomes das colunas da tabela, é possível ordenar os registros por usuário, oferta, valor e/ou data.

## ⏰ Jobs Agendados Automáticos

### Fechamento automático de ofertas expiradas

A plataforma possui uma job de background chamada **CloseExpiredFundraisesJob**. Ela é responsável por:
- Verificar, a cada 1 minuto, se existem ofertas do tipo Fundraise que já passaram do horário de término mas ainda estão com status aberto.
- Alterar automaticamente o status dessas ofertas para "closed".

#### Agendamento
- O agendamento é feito via [sidekiq-scheduler](https://github.com/sidekiq-scheduler/sidekiq-scheduler), configurado em `config/sidekiq.yml`.
- Frequência: **A cada 1 minuto** (cron: `* * * * *`).
- A job é enfileirada e executada na fila chamada **close_expired_fundraises_job**.

#### Monitoramento
- O processamento da job pode ser acompanhado no painel Sidekiq, acessível em `/sidekiq`.
- No dashboard, a fila `close_expired_fundraises_job` mostrará o número de jobs processados e eventuais falhas.

#### Exemplo de configuração (config/sidekiq.yml):
```yaml
:schedule:
  close_expired_fundraises_job:
    cron: '* * * * *'
    class: 'CloseExpiredFundraisesJob'
    queue: close_expired_fundraises_job
```

---

## 📦 Pré-requisitos

### Para rodar com Docker (Recomendado)
- [Docker](https://docs.docker.com/get-docker/) (v20+)
- [Docker Compose](https://docs.docker.com/compose/install/) (v2+)

### Para rodar localmente
- Ruby 3.2.2
- PostgreSQL 16
- Node.js 18+ (para Tailwind CSS)
- Bundler 2.5+

---

## 🐳 Instalação e Configuração

### Usando Docker (Recomendado)

#### 1. Clone o repositório
```bash
git clone https://github.com/alexandredfilho/simple-investment-platform
cd simple-investment-platform
git checkout feature/investments-implementation
```
#### 1.1 Importante: conflito com o PostgreSQL local
Se você estiver com o PostgreSQL rodando localmente, o Docker não conseguirá subir o container, pois ambos utilizam a mesma porta padrão (5432).
Antes de executar o projeto com Docker, pare o serviço local do PostgreSQL.

```bash
sudo systemctl stop postgresql
```

#### 2. Configure as variáveis de ambiente (opcional)
O projeto já vem com configurações padrão no `docker-compose.yml`. Se necessário, você pode criar um arquivo `.env`:

```env
DATABASE_HOST=db
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres
DATABASE_NAME=simple_investment_platform_development
```

#### 3. Construa e inicie os containers
```bash
docker compose up --build
```

Aguarde até ver a mensagem:
```
web_1  | * Listening on http://0.0.0.0:3000
```

#### 4. Configure o banco de dados (em outro terminal)
```bash
# Criar o banco de dados
docker compose exec web bin/rails db:create

# Rodar as migrations
docker compose exec web bin/rails db:migrate

# Popular com dados de exemplo
docker compose exec web bin/rails db:seed
```

#### 5. Acesse a aplicação
Abra seu navegador em: **http://localhost:3000**

#### 6. Parar os containers
```bash
docker compose down
```

#### 7. Resetar o banco de dados (se necessário)
```bash
docker compose exec web bin/rails db:reset
```

---

### Instalação Local

#### 1. Clone o repositório
```bash
git clone https://github.com/alexandredfilho/simple-investment-platform.git
cd simple-investment-platform
git checkout feature/investments-implementation
```

#### 2. Instale as dependências
```bash
bundle install
```

#### 3. Configure o banco de dados
Edite o arquivo `config/database.yml` com suas credenciais locais do PostgreSQL:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  host: localhost
  username: seu_usuario
  password: sua_senha
```

#### 4. Crie e configure o banco
```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

#### 5. Compile os assets (Tailwind CSS)
```bash
bin/rails tailwindcss:build
```

#### 6. Inicie o servidor
```bash
bin/rails server
```

#### 7. Acesse a aplicação
Abra seu navegador em: **http://localhost:3000**

---

## 📖 Como Usar

### 1. Navegue pelo Dashboard
- Acesse **http://localhost:3000**
- Visualize as estatísticas nos 4 cards
- Confira o gráfico de investimentos por usuário

### 2. Gerencie Usuários
- Clique em **"Usuários"** na navbar ou no card "Total de Usuários"
- **Criar novo usuário**: Clique em "Novo Usuário"
  - Nome: mínimo 1 caractere, máximo 255
  - Email: deve ser válido e único
- **Visualizar usuário**: Clique no nome do usuário
  - Veja o total investido
  - Veja todos os investimentos realizados

### 3. Gerencie Ofertas (Fundraises)
- Clique em **"Ofertas"** na navbar
- **Criar nova oferta**: Clique em "Nova Oferta"
  - Título: obrigatório
  - Descrição: opcional
  - Meta: valor em centavos (ex: 100000 = R$ 1.000,00)
  - Status: Aberta ou Fechada
  - Datas: use o **datepicker** para selecionar data/hora
- **Validação**: Data de término deve ser após data de início

### 4. Gerencie Investimentos
- Clique em **"Investimentos"** na navbar
- **Criar novo investimento**: Clique em "Novo Investimento"
  - Selecione um usuário
  - Selecione uma oferta (apenas ofertas ABERTAS)
  - Digite o valor em centavos
- **Validações aplicadas**:
  - ❌ Não permite investir em oferta fechada
  - ❌ Não permite valor zero ou negativo

### 5. Dados de Exemplo

Após rodar `bin/rails db:seed`, você terá:
- **3 usuários**: Alice, Bruno, Carla
- **2 ofertas**: 1 aberta e 1 fechada
- **8 investimentos** distribuídos entre os usuários

---

## 🧪 Executando os Testes

### Com Docker
```bash
# Executar todos os testes
docker compose run --rm web bin/rspec

# Executar testes de um arquivo específico
docker compose run --rm web bin/rspec spec/models/investment_spec.rb

# Executar um teste específico
docker compose run --rm web bin/rspec spec/models/investment_spec.rb:10

# Com formato de documentação
docker compose run --rm web bin/rspec --format documentation
```

### Localmente
```bash
# Executar todos os testes
bundle exec rspec

# Executar testes de um arquivo específico
bundle exec rspec spec/models/investment_spec.rb

# Com formato de documentação
bundle exec rspec --format documentation
```

### Cobertura de Testes

O projeto possui **50 testes** cobrindo:
- ✅ **Models**: Validações, associações, métodos personalizados
- ✅ **Requests**: CRUD completo de investments
- ✅ **Business Rules**: Não permitir investimento em oferta fechada

```
Finished in 0.62842 seconds
50 examples, 0 failures
```

---

## 📁 Estrutura do Projeto

```
simple-investment-platform/
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   ├── dashboards_controller.rb
│   │   ├── fundraises_controller.rb
│   │   ├── investments_controller.rb
│   │   └── users_controller.rb
│   ├── models/
│   │   ├── fundraise.rb          # Status (enumerize), validações customizadas
│   │   ├── investment.rb         # Validação de oferta aberta
│   │   └── user.rb
│   ├── views/
│   │   ├── dashboards/
│   │   ├── fundraises/
│   │   ├── investments/
│   │   ├── layouts/
│   │   │   ├── application.html.erb
│   │   │   └── _navbar.html.erb
│   │   └── users/
│   └── javascript/
│       └── controllers/
│           └── flatpickr_controller.js  # Stimulus controller para datepicker
│   ├── jobs/
│   │   ├── close_expired_fundraises_job.rb
├── config/
│   ├── database.yml                    # Configuração Docker-friendly
│   ├── routes.rb
│   └── initializers/
│       └── chartkick.rb
├── db/
│   ├── migrate/
│   ├── schema.rb
│   └── seeds.rb                        # Dados de exemplo
├── spec/
│   ├── factories/                      # FactoryBot
│   ├── models/
│   └── requests/
├── docker-compose.yml
├── Dockerfile.dev
└── README.md
```

---

## 🗄️ Modelo de Dados

### Relacionamentos

```
User (1) ──────< (N) Investment (N) >────── (1) Fundraise
```

### Tabelas

#### **users**
| Campo | Tipo | Validações |
|-------|------|------------|
| id | bigint | PK |
| name | string(255) | presence, max 255 |
| email | string | presence, uniqueness, format |
| created_at | datetime | - |
| updated_at | datetime | - |

#### **fundraises**
| Campo | Tipo | Validações |
|-------|------|------------|
| id | bigint | PK |
| title | string(255) | presence, max 255 |
| description | text | - |
| target_cents | integer | >= 0 |
| status | string | enum: [:open, :closed] |
| starts_at | datetime | - |
| ends_at | datetime | must be after starts_at |
| created_at | datetime | - |
| updated_at | datetime | - |

#### **investments**
| Campo | Tipo | Validações |
|-------|------|------------|
| id | bigint | PK |
| user_id | bigint | FK, presence |
| fundraise_id | bigint | FK, presence |
| amount_cents | integer | > 0 |
| created_at | datetime | - |
| updated_at | datetime | - |

**Índices:**
- `index_investments_on_user_id_and_fundraise_id` (composite)

**Validações customizadas:**
- Investment só pode ser criado se fundraise.status == :open

---

## 🎨 Capturas de Tela

### Dashboard
<img width="1110" height="1044" alt="Screenshot from 2025-10-26 23-11-32" src="https://github.com/user-attachments/assets/cd0348d8-8960-4bbf-b124-7927d90e6801" />

### Listagem de Usuários
<img width="1110" height="1044" alt="Screenshot from 2025-10-26 23-12-05" src="https://github.com/user-attachments/assets/f721856b-fb0d-40cc-a1c7-7ffe4db740d8" />

### Formulário de Oferta com Datepicker
<img width="1110" height="1044" alt="Screenshot from 2025-10-26 23-12-40" src="https://github.com/user-attachments/assets/79035867-1069-45a8-92e8-ba22bb96fc4e" />

### Perfil do Usuário
<img width="1110" height="1044" alt="Screenshot from 2025-10-26 23-13-19" src="https://github.com/user-attachments/assets/ff64a11d-b4df-4fd7-8559-6a55e0d60100" />

---

## 🛠️ Comandos Úteis

### Docker

```bash
# Iniciar containers
docker compose up

# Iniciar em background
docker compose up -d

# Parar containers
docker compose down

# Reconstruir containers
docker compose build --no-cache

# Ver logs
docker compose logs -f web

# Acessar console do Rails
docker compose exec web bin/rails console

# Acessar bash do container
docker compose exec web bash

# Executar migration
docker compose exec web bin/rails db:migrate

# Rollback migration
docker compose exec web bin/rails db:rollback

# Popular banco
docker compose exec web bin/rails db:seed

# Resetar banco (drop, create, migrate, seed)
docker compose exec web bin/rails db:reset
```

### Rails

```bash
# Console
bin/rails console

# Gerar migration
bin/rails generate migration CreateInvestments

# Rodar migrations
bin/rails db:migrate

# Ver rotas
bin/rails routes

# Limpar cache
bin/rails tmp:clear

# Rubocop (linter)
bundle exec rubocop

# Auto-fix rubocop
bundle exec rubocop -A
```

---
