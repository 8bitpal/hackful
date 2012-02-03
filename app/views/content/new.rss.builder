xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Hackful Europe - New posts"
    xml.description "A place for European entrepreneurs to share demos, stories or ask questions."
    xml.link "http://hackful.com"

    for post in @posts
      xml.item do
        xml.title post.title
        xml.description post.text
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link post_url(post)
        xml.guid post_url(post)
      end
    end
  end
end
