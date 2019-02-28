100.times do |i|
  Post.create(
    title: "title#{i + 1}",
    content: "# Hello, world",
    user_id: rand(11),
    status: i % 2 == 0 ? "公開中" : "下書き"
  )
end
