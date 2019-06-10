require 'securerandom'

user_names = %w(Taro Jiro Hana John Mike Sophy Bill Alex Tom Smile LongName)
user_names.each_with_index do |val, idx|
  user = User.create(
    name: val,
    email: val + "@example.com",
    password: "password",
  )

  rand(1..20).times do |i|
    Post.create(
      title: "title#{i + 1}",
      content: "# Hello, world",
      status: i % 2 == 0 ? "公開中" : "下書き",
      user_id: user.uuid,
      uuid: SecureRandom.hex(10),
    )
  end
end
