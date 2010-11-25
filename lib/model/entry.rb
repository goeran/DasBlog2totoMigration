# coding: utf-8
require 'htmlentities'
require 'prettyprinter'

class Entry
  include PrettyPrinter
  attr_accessor :Id
  attr_accessor :Date
  attr_accessor :Title
  attr_accessor :Content
  attr_accessor :Tags
  attr_accessor :Author

  def initialize(args = nil)
    self.Tags = []
    if args != nil then 
      self.Title = args[:title]
      self.Date = args[:date]
    end
  end
  
  def toto_filename
    if self.Title == nil then raise "Title is missing" end
    if self.Date == nil then raise "Date is missing" end

    filename = "#{pretty_print_date(self.Date)}-#{generate_valid_filename(self.Title)}.txt"
    filename.downcase!
    
    filename
  end
  
  def toto_date
    "#{self.Date.year}/#{pretty_int self.Date.month}/#{pretty_int self.Date.mday}"
  end
  
  def pretty_print_date(date)
    "#{self.Date.year}-#{pretty_int self.Date.month}-#{pretty_int self.Date.mday}"
  end
  
  def generate_valid_filename(str)
    result = remove_html_encoding(self.Title)
    result.gsub!(/\s/, "-")
    result.gsub!(/(\$|\!|\&|\#|\||\/|\@|;|\.|,|\?|\:|”|\"|’|\'|\(|\)|…)/, "")
    result
  end
  
  def to_yaml
    id = "id: #{self.Id}"
    title = "title: \"#{remove_html_encoding(self.Title.strip).gsub /\"/, "\\\""}\""
    author = "author: #{self.Author}"
    date = "date: #{toto_date}"
    tags_str = ""
    self.Tags.each do |tag| tags_str << tag << ";" end
    "#{title}\n#{author}\n#{date}\n#{id}\ntags: #{tags_str.gsub /;$/, ""}\n\n#{self.Content}"
  end
  
  def remove_html_encoding(content)
    content.gsub! /(&ndash;|&amp;ndash;)/, "-"
    content.gsub! /&amp;/, "&"
    content.gsub! /(&hellip;|&amp;hellip;)/, "..."
    
    coder = HTMLEntities.new
    result = coder.decode(content)
    
    result
  end
end