task :spec do
  sh "bundle exec rspec spec"
end

task :default do
 sh "RAILS='~>2' bundle && bundle exec rake spec"
 sh "RAILS='~>3.0.0' bundle && bundle exec rake spec"
 sh "RAILS='~>3.1.0' bundle && bundle exec rake spec"
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'key_value'
    gem.summary = "Abuse Sql database as Key-Value store"
    gem.email = "michael@grosser.it"
    gem.homepage = "http://github.com/grosser/#{gem.name}"
    gem.authors = ["Roman Heinrich","Michael Grosser"]
    gem.add_dependency 'activerecord'
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: gem install jeweler"
end
