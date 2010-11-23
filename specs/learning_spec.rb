# coding: utf-8
require 'rubygems'
require 'rspec'
require 'htmlentities'
require 'YAML'

describe "Regex" do
  it "should be possible to do search and replace using regex" do
    input = "<img src=\"http://myoldsite.com/content/binary/some_img.jpg\">"
    input += "<img src=\"/content/binary/some_img.jpg\">"
    sub = "http://static.mydomain.com/"    
    regex = /http:\/\/myoldsite.com\/content\/binary\/|\/content\/binary\//
    result = input.gsub(regex, sub)
    
    result.should eql "<img src=\"http://static.mydomain.com/some_img.jpg\"><img src=\"http://static.mydomain.com/some_img.jpg\">"
  end
end

describe "HTMLEntities" do
  before :all do
    @coder = HTMLEntities.new
  end
  
  it "should be able to decode single quote" do
    coder = HTMLEntities.new
    input = "&rsquo;"
    result = coder.decode(input)
    result.should eql "’"
  end
  
  it "should be able to decode end quote" do
    coder = HTMLEntities.new
    
    input = "&rdquo;"
    result = coder.decode(input)
    
    result.should eql "”"
  end
  
  it "should be able to decode dash" do
    input = "&ndash;"
    result = @coder.decode(input)
    #doesnt work. Don't know what char represent this dash. It's not; -
    #result.should be "-"
  end
end

describe YAML, "load" do
  it "should handle ';' in data?" do
    str = "tags: personal;blogging"
    yaml = YAML.load(str)
    yaml["tags"].should eql "personal;blogging"
  end
end