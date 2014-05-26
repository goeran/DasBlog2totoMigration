@root_dir = File.expand_path(File.join(File.dirname(__FILE__)))
$: << File.join(@root_dir, "lib")

require 'rubygems'
require 'dasblog'
require 'comments'
require 'migrate_to_toto'

comments = Comments.new(Dir.pwd  + "/specs/data/dasblog/content/2006-05-11.dayfeedback.xml")  

while comments.items.length > 0
  comment = comments.items[0]
  puts "Content: #{comment.Content}"
  puts
  print "Spam (y/n)? "
  answer = gets
    
  if answer == "y\n"
    removed = comments.mark_spam(comment)
    puts "Removed #{removed} spam comments... #{comments.items.length} to go..."
  elsif 
    comments.mark_clean(comment)
  end
  puts
end

comments.spam.each do |spam|
  puts "IP #{spam.IP} is a spammer"
end
