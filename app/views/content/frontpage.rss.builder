xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0", "xmlns:he" => 'http://hackful.com/rss/hackful' do
  xml.channel do
    xml.title "Hackful Europe - Top posts"
    xml.description "A place for European entrepreneurs to share demos, stories or ask questions."
    xml.link "http://hackful.com"

    for post in @posts
      xml.item do
        xml.title post.title
        xml.description markdown(post.text)
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link post.link
        xml.comments post_url(post)
        xml.guid post_url(post)
        xml.he :submitter, (post.user.nil? ? "[Deleted]" : post.user.name)
        xml.he :points, post.votes
        xml.he :commentcount, comment_count(post)
      end
    end
  end
end
