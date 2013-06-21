Fabricator(:donation, class_name: Boostify::Donation) do
  donatable  1
  charity    1
  amount     '9.99'
  commission '9.99'
  status     'MyString'
end
