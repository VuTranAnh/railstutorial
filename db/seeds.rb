User.create!(name: "Tran Anh Vu", email: "example@railstutorial.org",
  password: "password", password_confirmation: "password", admin: true,
  activated: true)

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n}@railstutorial.org"
  password = "password"
  puts "Creating sample user #{n}...."
  User.create!(name: name, email: email, password: password,
    password_confirmation: password, activated: true)
  puts "Done."
end

users = User.order(:created_at).take 6
50.times do
  content = Faker::Lorem.sentence 5
  users.each {|user| user.microposts.create! content: content}
end
