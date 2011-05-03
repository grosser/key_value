Abuse Sql database as Key-Value Store

Install
=======
    sudo gem install key_value

Migration
=========
`rails g migration create_key_value`

    class CreateKeyValue < ActiveRecord::Migration
      def self.up
        create_table :key_values do |t|
          t.string :key, :null => false
          t.text :value, :null => false
        end
        add_index :key_values, :key, :unique => true
      end

      def self.down
      end
    end

Usage
=====
    KeyValue.set('xxx', {:baz=>'foo'})
    KeyValue.get('xxx') -> {:baz=>'foo'}
    KeyValue.del('xxx')

TODO
====
 - Tests
 - .del

Authors
=======
[Roman Heinrich](https://github.com/mindreframer)<br/>
[Michael Grosser](http://grosser.it)<br/>
Hereby placed under public domain, do what you want, just do not hold anyone accountable...
