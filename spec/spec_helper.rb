require 'active_record'

# connect
if ENV['DB'] == 'mysql'
  puts 'using mysql'
  ActiveRecord::Base.establish_connection(
    :adapter => "mysql2",
    :database => "key_values_test"
  )
else
  puts 'using sqlite'
  ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database => ":memory:"
  )
end

# create tables
ActiveRecord::Schema.define(:version => 1) do
  drop_table :key_values rescue nil

  create_table :key_values do |t|
    t.string :key, :null => false
    t.text :value, :null => false
  end
  add_index :key_values, :key, :unique => true
end

$LOAD_PATH.unshift 'lib'
require 'key_value'
