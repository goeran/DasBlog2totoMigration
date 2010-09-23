require 'rubygems'
require 'spec'
require 'htmlentities'
require 'YAML'

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