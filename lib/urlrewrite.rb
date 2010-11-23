require 'toto'
require 'prettyprinter'

class UrlRewrite
  include PrettyPrinter
  
  def initialize toto_dir
    if toto_dir == nil then raise "toto dir must be specified" end
      
    @toto_dir = toto_dir
  end
  
  def permalinks
    old_articles = {}

    foreach_article do |metadata| 
      if metadata["id"] != nil then
        old_url = "/PermaLink,guid,#{metadata["id"]}.aspx"
        old_articles[old_url] = Date.parse(metadata["date"]).strftime("/%Y/%m/%d/#{metadata["title"].slugize}/")
      end
    end

    old_articles
  end

  def category_links
    old_categories = {}
    foreach_article do |metadata|
      if metadata["tags"] != nil then
        metadata["tags"].split(";").each do |tag|
          old_url = "/CategoryView,category,#{tag.gsub /\s/, "%2B"}.aspx"
          old_categories[old_url] = "/"
        end
      end
    end

    old_categories
  end

  def date_links
    links = {}
    foreach_article do |metadata|
      date = Date.parse(metadata["date"])
      links["/default,month,#{date.year}-#{pretty_int date.month}.aspx"] = "/#{date.year}/#{pretty_int date.month}/"
    end
    links
  end

  def comment_links
    links = {}
      foreach_article do |metadata|
        links["/CommentView,guid,#{metadata["id"]}.aspx"] = Date.parse(metadata["date"]).strftime("/%Y/%m/%d/#{metadata["title"].slugize}/")
      end
    links
  end

  def foreach_article
    Dir["#{@toto_dir}/articles/*.*"].each do |file|
      properties, body = File.read(file).split(/\n\n/, 2)
      metadata = YAML.load(properties)
      yield metadata
    end
  end
end

