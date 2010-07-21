desc 'Recaches main CRM data on the application'
task :recache => :environment do
  [Person, Company, Deal, Todo].each do |res|
    puts "Recaching #{res.name}..."
    res.recache
    puts "Finished recaching #{res.name}!\n\n\n"
  end
end