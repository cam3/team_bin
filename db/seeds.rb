# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#



0.upto(10000).each do |x|
  username = Faker::Internet.user_name
  email = Faker::Internet.free_email
  puts "#{username} <#{email}>"
  begin
    User.new(username: username, email: email).save(:validate => false)
  rescue
    next
  end
end
