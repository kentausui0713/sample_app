# ユーザーを追加する
User.create!( name: "Example User",
              email: "example@railstutorial.org",
              password: "foobar",
              password_confirmation: "foobar",
              admin: true,
              activated: true,
              activated_at: Time.zone.now
              )
              
# ユーザーをまとめて生成
99.times do |n|
  name  = Faker::JapaneseMedia::DragonBall.character
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now
               )
end

50.times do
  users = User.order(:created_at).take(6)
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { | user | user.microposts.create!(content: content) }
end




