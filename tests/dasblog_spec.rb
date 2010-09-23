require 'rubygems'
require 'spec'
require 'lib/dasblog'
require 'date'

av_nr_of_words = 10
av_char_pr_word = 5

Spec::Runner.configure do |config|
  config.before(:each) do
    @dasblog = Dasblog.new(Dir.pwd + "/tests/data/dasblog/")
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

