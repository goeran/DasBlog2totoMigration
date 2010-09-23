class Migrate_to_toto
  def initialize(toto_dir)
    if toto_dir == nil then raise "toto directory path must be specified" end
    if File.directory?(toto_dir) == false then raise "directory does not exists" end
    
    @toto_dir = toto_dir
  end
  
  def migrate(entries)
    if entries == nil then raise "entries must be specified" end
      
    entries.each do |entry|
      file = File.new("#{@toto_dir}/articles/#{entry.toto_filename}", "w+")
      file.puts entry.to_yaml
    end
  end
end