Fabricator(:charity, class_name: Boostify::Charity) do
  boost_id          { sequence(:boost_id) { |i| i + 1 } }
  title             Faker::Name.title
  name              Faker::Company.name
  url               Faker::Internet.url
  short_description Faker::Company.catch_phrase
  description       Faker::Company.bs
  logo              'where is the logo?'
end
