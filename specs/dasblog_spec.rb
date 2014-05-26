require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rubygems'
require 'rspec'
require 'dasblog'
require 'date'

av_nr_of_words = 10
av_char_pr_word = 5

RSpec.configure do |config|
  config.before(:each) do
    @dasblog = Dasblog.new(Dir.pwd + "/specs/data/dasblog/")
  end
end

describe "Search and replace" do
  it "should be possible to pass in a list of replacements" do    
    replacements = { /a/ => "A", /b/ => "B" }
    @dasblog = Dasblog.new(Dir.pwd + "/specs/data/dasblog/", replacements)    
  end
  
  it "should use the replacements to replace text in the content of the Entry" do
    replacements = {/http:\/\/blog.goeran.no\/content\/binary\// => "http://static.goeran.no/"}
    @dasblog = Dasblog.new(Dir.pwd + "/specs/data/dasblog/", replacements)    
    
    @dasblog.entries.each do |entry|
      entry.Content.include?("http://blog.goeran.no/content/binary/").should == false
    end    
  end
end

describe "When get entires" do
  it "should return a resultset" do
    @dasblog.entries.count.should_not eql 0
    @dasblog.entries.class.should eql Array
  end
  
  it "should return a resultset with Entry objects" do
    @dasblog.entries.each do |entry|
      entry.class.should eql Entry
    end
  end
  
  it "should have parsed Title for entries" do
    @dasblog.entries.each do |entry|
      entry.Title.should_not eql nil
      entry.Title.length.should be > 5
    end
  end
  
  it "should have parsed Content for entries" do
    @dasblog.entries.each do |entry|
      entry.Content.should_not eql nil
      entry.Content.length.should be > av_nr_of_words * av_char_pr_word 
    end
  end
  
  it "should have parsed Tags for entries" do
    @dasblog.entries.each do |entry|
      entry.Tags.should_not eql nil
      entry.Tags.count.should be > 0
    end
  end
  
  it "Should have parsed Id for entries" do
    @dasblog.entries.each do |entry|
      entry.Id.should_not eql nil
    end
  end
  
  it "Should have parsed Date for entries" do
    @dasblog.entries.each do |entry|
      entry.Date.should_not eql nil
      entry.Date.class.should be DateTime
    end
  end
end

