require 'toto'
require 'lib/dasblog'
require 'lib/migrate_to_toto'

task :default => :migrate_dasblog

desc "Migrate from dasblog."
task :migrate_dasblog, :dasblog_dir, :toto_dir, :author do |t, args|  
  validate args
  
  puts "migration starts"
  dasblog = Dasblog.new(Dir.pwd + args[:dasblog_dir])
  entries = dasblog.entries
  entries.each do |entry|
    entry.Author = args[:author]
  end
  puts "Articles migrated: #{dasblog.entries.count}" 
  migrate_to_toto = Migrate_to_toto.new Dir.pwd + args[:toto_dir]
  migrate_to_toto.migrate entries
end


def validate args
  if File.directory?(Dir.pwd + args[:dasblog_dir]) == false then
    puts "Dasblog dir not found" 
    print_help
    abort
  end
  
  if File.directory?(Dir.pwd + args[:toto_dir]) == false then
     puts "Toto dir not found"
     print_help
     abort
  end
  
  if args[:author] == nil or args[:author] == "" then
    puts "Author is not specified"
    print_help
    abort    
  end
end

def print_help
  puts "Correct usage: rake migrate_dasblog[/relDirToDasBlog,/relativeDirToToto,\"Author name\"]"
end
