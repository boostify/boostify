Fabricator(:charity, class_name: Boostify::Charity) do
  boost_id          Random.rand(100)
  title             Faker::Name.title
  name              Faker::Company.name
  url               Faker::Internet.url
  short_description Faker::Company.catch_phrase
  description       Faker::Company.bs
  logo              'where is the logo?'
  income            (Random.rand(10_000) / 100.0)
  advocates         Random.rand(1_000)
end
