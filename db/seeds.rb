puts 'Limpando banco de dados...'
Investment.destroy_all
Fundraise.destroy_all
User.destroy_all

puts 'Criando usuários...'
alice = User.create!(name: 'Alice', email: 'alice@example.com')
bruno = User.create!(name: 'Bruno', email: 'bruno@example.com')
carla = User.create!(name: 'Carla', email: 'carla@example.com')

puts 'Criando ofertas...'
oferta1 = Fundraise.create!(
  title: 'oferta 1',
  description: 'Primeira oferta de teste',
  target_cents: 100_000,
  status: 'open',
  starts_at: Time.current,
  ends_at: 30.days.from_now
)

oferta2 = Fundraise.create!(
  title: 'oferta 2',
  description: 'Segunda oferta de teste',
  target_cents: 200_000,
  status: 'open',
  starts_at: Time.current,
  ends_at: 60.days.from_now
)

oferta3 = Fundraise.create!(
  title: 'oferta 3',
  description: 'oferta já encerrada',
  target_cents: 150_000,
  status: 'closed',
  starts_at: 60.days.ago,
  ends_at: 30.days.ago
)

puts 'Criando investimentos...'
Investment.create!([
  { user: alice, fundraise: oferta1, amount_cents: 25_000 },
  { user: alice, fundraise: oferta2, amount_cents: 50_000 },
  { user: bruno, fundraise: oferta1, amount_cents: 30_000 },
  { user: bruno, fundraise: oferta2, amount_cents: 75_000 },
  { user: carla, fundraise: oferta1, amount_cents: 20_000 },
  { user: carla, fundraise: oferta2, amount_cents: 40_000 },
  { user: alice, fundraise: oferta2, amount_cents: 15_000 }
])

puts 'Seeds criados com sucesso!'
puts 'Total de usuários: #{User.count}'
puts 'Total de ofertas: #{Fundraise.count}'
puts 'Total de investimentos: #{Investment.count}'
