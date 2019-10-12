module GenerateTagHelper
  def make_tag(tagnames)
    tag_list = []
    tagnames.map do |tagname|
      tag_list.concat << tag.span(class: "tag_name") { |tag| tagname }
    end
    tag_list.join.html_safe
  end

  def make_link_tag(tagnames)
    tag_list = []
    tagnames.map do |tagname|
      tag_list.concat << tag.a(href: tag_path(tagname), class: "tag_link") do |tag|
        tag.div(class: "tag_name") { |tag| tagname }
      end
    end
    tag_list.join.html_safe
  end
end
