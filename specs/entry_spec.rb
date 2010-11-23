# coding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')
require 'date'
require 'rspec'
require 'model/entry'

describe Entry, "generate toto filename when Title is missing" do
  it "should raise exception" do
    entry = Entry.new
    lambda { entry.toto_filename }.should raise_exception "Title is missing"
  end
end

describe Entry, "generate toto filename when Date is missing" do
  it "should raise exception" do
    entry = Entry.new
    entry.Title = "hello world"
    
    lambda { entry.toto_filename }.should raise_exception "Date is missing"
  end
end

describe Entry, "generate toto filename" do
  before :all do
    @entry = Entry.new
    @entry.Date = Date.new 1981, 9, 1
  end
  
  it "should generate correct toto filename" do
    @entry.Title = "hello world"
    @entry.toto_filename.should eql "1981-09-01-hello-world.txt"
  end
  
  it "should include dashes from title" do
    @entry.Title = "Hello - world"
    @entry.toto_filename.should eql "1981-09-01-hello---world.txt"
  end
  
  it "should be all lower case" do
    @entry.Title = "Remember NNUG in Trondheim tomorrow"
    @entry.toto_filename.should eql "1981-09-01-remember-nnug-in-trondheim-tomorrow.txt"
  end
end

describe Entry, "generate toto filename when Title contains invalid chars for a filename" do
  it "should exclude the invalid chars" do
    entry = Entry.new
    entry.Date = DateTime.parse "01.09.1981"
    entry.Title = "hello!_$world#&|/@;.?\""
    
    entry.toto_filename.should eql "1981-09-01-hello_world.txt"
  end
  
  it "should exclude the ' char" do
    entry = Entry.new
    entry.Date = DateTime.parse "01.09.1981"
    entry.Title = "A Software Craftsman&rsquo;s Bookshelf"
    
    entry.toto_filename.should eql "1981-09-01-a-software-craftsmans-bookshelf.txt"
  end
end

describe Entry, "generate toto filename regression tests" do
  #testing posts that failed to migrate
  
  before :all do
    @entry = Entry.new
  end
  
  it "should remove invalid chars from: NNUG Presentation: OOP Back to Basic" do
    @entry.Date = Date.new 2009, 3, 3
    @entry.Title = "NNUG Presentation: OOP Back to Basic"
    @entry.toto_filename.should eql "2009-03-03-nnug-presentation-oop-back-to-basic.txt"
  end
  
  it "should remove invalid chars from: The story about the Macbook Aluminum 13” SSD hard drive upgrade!" do
    @entry.Date = Date.new 2009, 2, 27
    @entry.Title = "The story about the Macbook Aluminum 13&amp;rdquo; SSD hard drive upgrade!"
    @entry.toto_filename.should eql "2009-02-27-the-story-about-the-macbook-aluminum-13-ssd-hard-drive-upgrade.txt"
  end
  
  it "should remove invalid chars from: Everything is amazing, and nobody is happy&amp;hellip;" do
    @entry.Date = Date.new 2009, 3, 23
    @entry.Title = "Everything is amazing, and nobody is happy&amp;hellip;"
    @entry.toto_filename.should eql "2009-03-23-everything-is-amazing-and-nobody-is-happy.txt"
  end
  
  it "should remove invalid chars from: What's your Circle of Interest?" do
    @entry.Title = "What's your Circle of Interest?"
    @entry.Date = Date.new 2008, 5, 14
    @entry.toto_filename.should eql "2008-05-14-whats-your-circle-of-interest.txt"
  end
  
  it "should remove invalid chars from: Microsoft Student Community 2007 kick-off" do
    @entry.Title = "Microsoft Student Community 2007 kick-off"
    @entry.Date = Date.new 2007, 10, 12
    @entry.toto_filename.should eql "2007-10-12-microsoft-student-community-2007-kick-off.txt"
  end
  
  it "should remove invalid chars from: UncleBob&amp;rsquo;s keynote from RailsConf2009 &amp;ndash; the most inspiring talk I&amp;rsquo;ve ever heard!" do
    @entry.Title = "UncleBob&amp;rsquo;s keynote from RailsConf2009 &amp;ndash; the most inspiring talk I&amp;rsquo;ve ever heard!"
    @entry.Date = Date.new 2009, 5, 12
    @entry.toto_filename.should eql "2009-05-12-unclebobs-keynote-from-railsconf2009---the-most-inspiring-talk-ive-ever-heard.txt"
  end
end

describe Entry, "when generate yaml" do
  before :all do
    @entry = Entry.new
    @entry.Title = "Programming by \"coincidence\""
    @entry.Author = "goeran"
    @entry.Date = Date.new 1981, 9, 1
    @entry.Content = "hello world"
    @entry.Id = "5aaf56ce-cbe5-4df1-99e2-55f606d65a8d"
    @entry.Tags.push "blogging", "personal", "new blog"
  end
  
  it "should exclude the invalid chars in Title" do
    @entry.to_yaml.include?("title: \"Programming by \\\"coincidence\\\"\"").should be true  
  end
  
  it "should include author" do
    @entry.to_yaml.include?("author: goeran").should be true
  end
  
  it "should include date" do
    @entry.to_yaml.include?("date: 1981/09/01").should be true
  end

  it "should include content" do
    @entry.to_yaml.include?("hello world").should be true
  end
  
  it "should include id" do
    @entry.to_yaml.include?("id: 5aaf56ce-cbe5-4df1-99e2-55f606d65a8d").should be true
  end
  
  it "should include Tags" do
    puts @entry.to_yaml
    @entry.to_yaml.include?("tags: blogging;personal;new blog\n").should be true
  end
end