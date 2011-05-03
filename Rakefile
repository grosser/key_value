task :default do
  sh "rspec spec/"
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'key_value'
    gem.summary = "Abuse"
    gem.email = "michael@grosser.it"
    gem.homepage = "http://github.com/grosser/#{gem.name}"
    gem.authors = ["Michael Grosser"]
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: gem install jeweler"
end
