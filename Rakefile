task :spec do
  sh "bundle exec rspec spec"
end

task :ar2 do
  sh "cd spec/ar2 && bundle exec rspec ../../spec"
end

task :default do
  sh "rake spec && rake ar2"
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'key_value'
    gem.summary = "Abuse Sql database as Key-Value store"
    gem.email = "michael@grosser.it"
    gem.homepage = "http://github.com/grosser/#{gem.name}"
    gem.authors = ["Roman Heinrich","Michael Grosser"]
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: gem install jeweler"
end
