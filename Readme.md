Abuse Sql database as Key-Value Store

Install
=======
    sudo gem install key_value

Migration
=========
`rails g migration create_key_value`

    class CreateKeyValue < ActiveRecord::Migration
      def self.up
        create_table :key_values, :id => false do |t|
          t.string :key, :null => false, :primary => true
          t.text :value, :null => false
        end
      end

      def self.down
        drop_table :key_values
      end
    end

Usage
=====
    # get
    KeyValue['xxx'] -> {:baz=>'foo'}
    or KeyValue.get('xxx') -> {:baz=>'foo'}

    # set
    KeyValue['xxx'] = {:baz=>'foo'})
    or KeyValue.set('xxx', {:baz=>'foo'})

    # delete
    KeyValue['xxx'] = nil
    or KeyValue.del('xxx')

    # increment
    KeyValue.inc('xxx') # !! Not atomic
    or KeyValue.inc('xxx', 5)

    # cache
    KeyValue.cache('xxx'){ ..something expensive.. }

HandlerSocket for [750k-qps](http://yoshinorimatsunobu.blogspot.com/2010/10/using-mysql-as-nosql-story-for.html),
[Ubuntu natty guide](http://grosser.it/2011/05/14/installing-mysql-handlersocket-in-ubuntu-natty-for-ruby/)

    KeyValue.handler_socket = {:host => '127.0.0.1', :port=>'9998', :database => 'foo_development'}

    # all read requests use HandlerSocket
    KeyValue['xxx'] # -> same as before but faster :)

TODO
====
 - nice error handling for HandlerSocket
 - reuse host/database from normal connection for HandlerSocket
 - HandlerSocket write support
 - make test database configurable

Authors
=======
[Roman Heinrich](https://github.com/mindreframer)<br/>
[Michael Grosser](http://grosser.it)<br/>
Hereby placed under public domain, do what you want, just do not hold anyone accountable...
