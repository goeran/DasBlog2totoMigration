# coding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')
require 'date'
require 'rspec'
require 'model/entry'
require 'migrate_to_toto'

RSpec.configure do |config|
  config.before(:each) do
    @entries = []
    @entries.push Entry.new({ :title => "hello world", :date => Date.new(1981, 9, 1)})
    @entries.push Entry.new({ :title => "Ruby is a great language", :date => Date.new(1986, 5, 20) })

    @migrate_to_toto = Migrate_to_toto.new Dir.pwd
  end
end

describe "When spawning" do
  it "should validate toto_dir arg" do 
    lambda { Migrate_to_toto.new nil }.should raise_exception "toto directory path must be specified"
  end
  
  it "should raise exception if toto_dir does not exists" do
    lambda { Migrate_to_toto.new "#{Dir.pwd}/doesnotexist" }.should raise_exception "directory does not exists"
  end
end

describe "When migrate" do
  it "should validate entries arg" do
    lambda { @migrate_to_toto.migrate nil }.should raise_exception
  end
  
  it "should create files in 'articles' directory for each entry" do
    nr_of_files_created = 0
    file = mock("File", :puts => true)
    File.stub!(:new).and_return do |args|
      if args.include?("redirect.rb") == false
        nr_of_files_created += 1
      end
      file
    end
    
    @migrate_to_toto.migrate @entries
    
    nr_of_files_created.should be @entries.count
  end  
  
  it "should create redirect.rb in root folder" do
    files_created = {}
    file = mock("File", :puts => true)
    File.stub!(:new).and_return do |args|
      files_created[args] = true
      file
    end
   
    @migrate_to_toto.migrate @entries
    
    files_created[Dir.pwd + "/redirect.rb"].should == true  
  end
end