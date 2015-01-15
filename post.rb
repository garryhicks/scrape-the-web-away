class Post

  attr_accessor :comments
  def initialize(title,url,points,post_item_id,comments)
    @title =        title
    @url =          url
    @points =       points
    @post_item_id = post_item_id
    @comments =     comments
  end

  def add_comment(comment)
    @comments_array << comment
  end

end

