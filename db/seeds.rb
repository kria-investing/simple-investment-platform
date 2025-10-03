puts "Criando usuários..."
User.create!([
  { name: "Alice", email: "alice@example.com" },
  { name: "Bruno", email: "bruno@example.com" },
  { name: "Carla", email: "carla@example.com" }
])

puts "Criando ofertas..."
Fundraise.create!([
  {
    title: "oferta 1",
    description: "Primeira oferta de teste",
    target_cents: 100_000,
    status: "open",
    starts_at: Time.current,
    ends_at: 30.days.from_now
  },
  {
    title: "oferta 2",
    description: "Segunda oferta de teste",
    target_cents: 200_000,
    status: "open",
    starts_at: Time.current,
    ends_at: 60.days.from_now
  },
  {
    title: "oferta 3",
    description: "oferta já encerrada",
    target_cents: 150_000,
    status: "closed",
    starts_at: 60.days.ago,
    ends_at: 30.days.ago
  }
])

puts "Seeds criados com sucesso!"
