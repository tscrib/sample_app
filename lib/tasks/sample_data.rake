namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    # Make the first user an admin
    admin = User.create!(name: "Tim Scribner",
     email: "tim.scribner@gmail.com",
     password: "foobar",
     password_confirmation: "foobar")
    admin.toggle!(:admin)

    # create 99 users
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
       email: email,
       password: password,
       password_confirmation: password)
    end

    # populate the first 6 users with 50 microposts each
    users = User.all(limit: 6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content) }
    end
  end
end