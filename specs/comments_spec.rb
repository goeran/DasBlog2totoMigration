# coding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rspec'
require 'urlrewrite'
require 'dasblog'
require 'comments'

RSpec.configure do |config|
  config.before() do
    @comments = Comments.new(Dir.pwd + "/specs/data/dasblog/content/2007-01-17.dayfeedback.xml")
    @items = @comments.items
    @firstItem = @comments.items[0]
  end
end

describe "We need to determine if a comment is spam or not" do  
  it "should read all comments from file into list" do
    @items.count.should eql 3
  end
  
  it "should read the author IP address" do
    @firstItem.IP.should eql "202.74.164.3"
  end
  
  it "should add the author home page to list of urls" do    
    @firstItem.Urls[0].should eql "www.dwuvk.cmkquh.com"
  end
  
  it "should read out the comment" do
    @firstItem.Content.length.should > 0
  end
  
  it "should only read the first 200 chars" do
    @firstItem.Content.length.should <= 200
    @items[1].Content.length.should <= 200
  end
  
  it "should keep a list of spam messages" do
    @comments.mark_spam(@firstItem)
    @comments.spam.length.should eql 1
  end
  
  it "should remove other messages from spammer" do
    @comments.items.length.should eql 3
    @comments.mark_spam(@comments.items[0])
    @comments.items.length.should eql 1
  end
  
  it "should return the number of spam messages removed" do
    spam_removed = @comments.mark_spam(@comments.items[0])
    spam_removed.should eql 2
  end
  
  it "should remove a clean comment form the list" do 
    @comments.items.length.should eql 3
    @comments.mark_clean(@comments.items[0])
    @comments.items.length.should eql 2    
  end
end












