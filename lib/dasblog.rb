require 'date'
require 'rexml/document'
require 'model/entry'

class Dasblog
  def initialize(path)
    @path = path + "content"
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
    entry.Tags = post_xml.elements["Categories"].text.split(";")
    entry.Date = DateTime.parse post_xml.elements["Created"].text
    entry
  end
end
