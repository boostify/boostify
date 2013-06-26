Fabricator(:donation, class_name: Boostify::Donation) do
  # donatable
  charity
  amount     Money.new(100, 'EUR')
  commission Money.new(200, 'EUR')
  status     'MyString'
end
