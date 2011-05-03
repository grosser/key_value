require 'active_record'

# connect                                                                                                                                                                                                                                     
ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => ":memory:"
)

# create tables
ActiveRecord::Schema.define(:version => 1) do
  create_table :key_values do |t|
    t.string :key, :null => false
    t.text :value, :null => false
  end
  add_index :key_values, :key, :unique => true
end

$LOAD_PATH.unshift 'lib'
require 'key_value'
