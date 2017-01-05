User.create!(name: "Tran Anh Vu", email: "example@railstutorial.org",
  password: "password", password_confirmation: "password", admin: true)

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n}@railstutorial.org"
  password = "password"
  puts "Creating sample user #{n}...."
  User.create!(name: name, email: email, password: password,
    password_confirmation: password)
  puts "Done."
end
