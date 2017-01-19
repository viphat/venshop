# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(name: 'Administrator', email: 'admin@zigexn.vn', password: 'admin')

# Assuming that We've already imported Items from Amazon
# Import Items
Item.all.each do |item|
  item.inventory_items.create(
    status: :imported,
    quantity: 10
  )
end
