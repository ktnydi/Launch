user_names = %w(Taro Jiro Hana John Mike Sophy Bill Alex Tom Smile)
user_names.each_with_index do |val, idx|
  User.create(
    name: val,
    email: val + "@example.com",
    password: "password",
    image_name: "default.png"
  )
end
