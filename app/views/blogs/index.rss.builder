xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title blog_title(@user)
    xml.description blog_title(@user)
    # xml.link formatted_blogs_url(:rss, :user => @user.login)
    
    for blog in @blogs
      xml.item do
        xml.title blog.title
        xml.description blog.body
        xml.pubDate blog.created_at.to_s(:rfc822)
        xml.link formatted_blog_url(blog, :rss)
        xml.guid formatted_blog_url(blog, :rss)
      end
    end
  end
end