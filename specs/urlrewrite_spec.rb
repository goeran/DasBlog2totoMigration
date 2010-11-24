# coding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rspec'
require 'urlrewrite'

url_rewrite = UrlRewrite.new Dir.pwd + "/specs/data/toto"

describe UrlRewrite, "initialize" do
  it "should validate toto dir arg" do
    lambda { UrlRewrite.new nil }.should raise_exception "toto dir must be specified"
  end
end

describe "When generate dasblog permalinks" do
  before :each do
    @old_urls = url_rewrite.permalinks
  end
  
  it "should return the old urls that looks like this: PermaLink,guid,e55bfb55-ac10-48db-98a4-d28343e0f98a.aspx" do
    @old_urls.each do |old, new| 
      old.match(/^\/PermaLink,guid,(\d|\w){8}-(\d|\w){4}-(\d|\w){4}-(\d|\w){4}-(\d|\w){12}\.aspx$/).should_not be nil
    end
  end
  
  it "should return the new urls that looks like this: /2010/09/01/new-blog-engine/" do
    @old_urls.each do |old, new_url|
      new_url.match(/^\/\d{4}\/\d{2}\/\d{2}\/(\w|-)*\//).should_not be nil
    end
  end
end

describe "do regration tests" do
  before :each do
    @old_urls = url_rewrite.permalinks
  end
  
  it "'/PermaLink,guid,5aaf56ce-cbe5-4df1-99e2-55f606d65a8d.aspx' should point to '/2009/07/21/reinstalling-windows-home-server-system-disk/'" do
    @old_urls["/PermaLink,guid,5aaf56ce-cbe5-4df1-99e2-55f606d65a8d.aspx"].should eql "/2009/07/21/reinstalling-windows-home-server-system-disk/"
  end
end

describe "When generate links" do
  before :each do
    @links = url_rewrite.category_links
    @links.merge! url_rewrite.permalinks
    @links.merge! url_rewrite.date_links
    @links.merge! url_rewrite.comment_links
  end
  
  it "should return a hash" do
    @links.class.should eql Hash
  end
  
  it "should return several urls" do
    @links.count.should be > 1
  end

end

describe "When generate dasblog category links" do
  before :each do
    @old_urls = url_rewrite.category_links
  end
  
  it "should return old urls that looks like this: /CategoryView,category,Sync Services for ADO.NET.aspx" do
    @old_urls.each do |old_url, new_url| 
      old_url.match(/^\/CategoryView,category,.*.aspx$/).should_not be nil
    end
  end
  
  it "should return new urls that points to / (main page)" do
    @old_urls.each do |old_url, new_url| 
      new_url.should eql "/"
    end
  end
end

describe "When generate dasblog date links" do
  before :each do
    @links = url_rewrite.date_links
  end
  
  it "should return old links that looks like this: /default,month,2007-03.aspx" do
    @links.each do |old_link, new_link|
      old_link.match(/^\/default,month,\d{4}-\d{2}.aspx$/).should_not be nil
    end
  end
  
  it "should redirect old links to new links like this: /2007/03" do
    @links.each do |old_link, new_link|
      new_link.match(/^\/\d{4}\/\d{2}\/$/).should_not be nil
    end
  end
end

describe "When generate dasblog comment links" do
  it "should return old links that looks like this: /CommentView,guid,5aaf56ce-cbe5-4df1-99e2-55f606d65a8d.aspx" do
    @links = url_rewrite.comment_links
    @links.each do |old_link, new_link|
      old_link.match(/^\/CommentView,guid,.*.aspx$/).should_not be nil
    end
  end
  
  it "should redirect old links to new links like this: /2009/07/21/reinstalling-windows-home-server-system-disk/" do
    @links = url_rewrite.comment_links
    @links["/CommentView,guid,5aaf56ce-cbe5-4df1-99e2-55f606d65a8d.aspx"].should eql "/2009/07/21/reinstalling-windows-home-server-system-disk/"
  end
end