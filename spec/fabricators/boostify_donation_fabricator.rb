Fabricator(:donation, class_name: Boostify::Donation) do
  donatable  { Fabricate :transaction }
  charity
  amount     Money.new(100, 'EUR')
  commission Money.new(200, 'EUR')
  status     'MyString'
end
