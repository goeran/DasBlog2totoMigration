@root_dir = File.expand_path(File.join(File.dirname(__FILE__)))
$: << File.join(@root_dir, "lib")

require 'toto'
require 'dasblog'
require 'migrate_to_toto'

task :default => :migrate_dasblog

desc "Migrate from dasblog."
task :migrate_dasblog, :config_file do |t, args|    
  
  if args[:config_file] == nil
    args = {:config_file => "config.yaml"}
  end  
  validate_arguments args
  
  config = YAML::load(File.open(args[:config_file]))
  puts config
  validate_config config
  
  puts "migration starts"
  dasblog = Dasblog.new(Dir.pwd + config["dasblog_dir"])
  entries = dasblog.entries
  entries.each do |entry|
    entry.Author = config["author"]
  end
  puts "Articles migrated: #{dasblog.entries.count}" 
  migrate_to_toto = Migrate_to_toto.new Dir.pwd + config["toto_dir"]
  migrate_to_toto.migrate entries
end


def validate_arguments args  
  if File.exist?(Dir.pwd + "/" + args[:config_file]) == false then
    puts "Configuration file not found #{Dir.pwd}#{args[:config_file]}"
    print_help
    abort
  end
end

def validate_config args
  if File.directory?(Dir.pwd + args["dasblog_dir"]) == false then
    puts "Dasblog dir not found" 
    print_help
    abort
  end
  
  if File.directory?(Dir.pwd + args["toto_dir"]) == false then
     puts "Toto dir not found"
     print_help
     abort
  end
  
  if args["author"] == nil or args["author"] == "" then
    puts "Author is not specified"
    print_help
    abort    
  end
end

def print_help
  puts "Correct usage: rake migrate_dasblog[config_file.yaml]"
end
