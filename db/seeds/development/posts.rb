50.times do |i|
  Post.create(
    title: "title#{i + 1}",
    content: "# Hello, world",
    user_id: rand(11)
  )
end
