Fabricator(:transaction) do
  my_amount Money.new(120, 'EUR')
  my_commission Money.new(70, 'EUR')
end
