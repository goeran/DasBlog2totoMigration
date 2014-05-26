require 'date'
require 'rexml/document'
require 'model/entry'

class Dasblog

  def initialize(path, replacements={})
    @path = path + "content"
    @replacements = replacements        
  end
  
  def entries
    entries = []
    
    files = Dir.entries(@path)
    files.each do |f|
      if f.include? ".dayentry.xml"
        File.open @path + "/" + f do |stream|
          xml = REXML::Document.new(stream)
          xml.root.elements.each("Entries/Entry") do |post_xml|
            entries.push parse_entry(post_xml)
          end
        end
      end
    end
    entries
  end
  
  def parse_entry(post_xml)
    entry = Entry.new
    entry.Id = post_xml.elements["EntryId"].text
    entry.Title = post_xml.elements["Title"].text
    entry.Content = post_xml.elements["Content"].text
    
    if(post_xml.elements["Categories"].text != nil)
      entry.Tags = post_xml.elements["Categories"].text.split(";")
    end
    entry.Date = DateTime.parse post_xml.elements["Created"].text
    
    @replacements.each do |regex,replace|
      entry.Content = entry.Content.gsub(regex, replace)
    end
    
    entry
  end
end
