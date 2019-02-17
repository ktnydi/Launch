30.times do |i|
  Post.create(
    title: "title#{i}",
    content: "#Hello, world"
  )
end
