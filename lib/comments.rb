require 'model/comment'

class Array
  def contains? array
    array.each do |item|
      if self.include? item
        return true
      end
    end
    false
  end
end

class Comments
  
  def initialize(path)
    @path = path
    @spam = []
    @items = []
    
    File.open @path do |stream|
      xml = REXML::Document.new(stream)
      xml.root.elements.each("Comments/Comment") do |comment_xml|
        comment = Comment.new
        comment.Urls = []
        comment.IP = comment_xml.elements["AuthorIPAddress"].text
        
        url = comment_xml.elements["AuthorHomepage"].text
        if(url != nil)
          comment.Urls.push get_domain(url)
        end
        
        comment.Content = comment_xml.elements["Content"].text[0...200]
        items.push comment
      end
    end
  end
  
  def get_domain(url)    
    url[/http:\/\/([^?#\/]+)/, 1]
  end
  
  def items
    @items
  end
  
  def spam
    @spam
  end
  
  def mark_spam(comment)
    @spam.push comment
    
    new_spam = []
    @items.each do |item|
      if item.IP == comment.IP
        new_spam.push item
      elsif item.Urls.contains? comment.Urls
        new_spam.push item
      end
    end 
    
    @items = @items - new_spam
    new_spam.length
  end
  
  def mark_clean(comment)
    @items = @items - [comment]
  end
end