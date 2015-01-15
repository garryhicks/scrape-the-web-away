require 'byebug'
require 'nokogiri'
require 'open-uri'
require './post'
require './comment'

def run
  new_post(title,url,points,post_item_id,comments)
end

def get_doc(url)
  Nokogiri::HTML((File.open(url)))
end

def get_title(doc)
  title = doc.search('td.title > a').inner_text
  title
end

def get_url(doc)
  doc.css('td.title > a')[0].attributes["href"].value
end

def get_points(doc)
  doc.css('td.subtext > span')[0].inner_text
end

def get_post_item_id(doc)
  both = doc.css('td.subtext > a:nth-child(3)')[0].attributes["href"].value
  both.split("=")[1]
end

def get_comment_item_id(doc,i)
  both = doc.css('.comhead > a:nth-child(2)')[i].attributes["href"].value
  both.split("=")[1]

end

def get_comment_text(doc,i)
  doc.search('.comment > font:first-child').map { |font| font.inner_text}[i]
end

def get_username(doc,i)
  doc.css('.comhead > a:first-child')[i].children.inner_text
end

def get_link(doc,i)
  doc.css('.comhead > a:nth-child(2)')[i]["href"]
end


def get_comments(doc)
  @comments_array = []
  comments = doc.css('.comment > font')
  i = 0
  comments.each do |comment|
    post_item_id=     get_post_item_id(doc)
    comment_item_id=  get_comment_item_id(doc,i)
    username=         get_username(doc,i)
    link=             get_link(doc,i)
    comment=          get_comment_text(doc,i)
    new_comment= Comment.new(post_item_id, comment_item_id, username, link, comment)
    puts new_comment.inspect
    puts "\n"
    i = i + 1
    @comments_array << new_comment
    
  end
  @comments_array
end

def new_post(doc)
  title=        get_title(doc)
  url=          get_url(doc)
  points=       get_points(doc)
  post_item_id= get_post_item_id(doc)
  comments=     get_comments(doc)     
  Post.new(title,url,points,post_item_id, comments)
end

@doc = get_doc('post.html')

# Post methods

# new_post(@doc)

get_comments(@doc)





