Fabricator(:donation, class_name: Boostify::Donation) do
  donatable  1
  charity    1
  amount     Money.new(100, 'EUR')
  commission Money.new(200, 'EUR')
  status     'MyString'
end
