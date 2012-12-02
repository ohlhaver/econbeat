		xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do

  xml.url do
    xml.loc "https://www.EconBloggers.com"
    xml.priority 1.0
  end

  @authors.each do |a|
    author = Author.find(a)
    xml.url do
      xml.loc author_url(author)
      xml.lastmod author.updated_at.to_date
      xml.priority 0.9
    end
  end

end