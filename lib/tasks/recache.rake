desc 'Recaches main CRM data on the application'
task :recache => :environment do
  BatchBook::boot
  [BatchBook::Person, BatchBook::Company, BatchBook::Deal, BatchBook::Todo, BatchBook::Communication].each do |res|
    puts "Recaching #{res.clean_name}..."
    res.recache
    puts "Finished recaching #{res.clean_name}!\n\n\n"
  end
end