Abuse Sql database as Key-Value Store that can be [750k-qps-crazy-fast](http://yoshinorimatsunobu.blogspot.com/2010/10/using-mysql-as-nosql-story-for.html) via HandlerSocket

Install
=======
    sudo gem install key_value

Migration
=========
`rails g migration create_key_value` and paste in:

    class CreateKeyValue < ActiveRecord::Migration
      def self.up
        create_table :key_values do |t|
          t.string :key, :null => false
          t.text :value, :null => false
        end
        add_index :key_values, :key, :unique => true
      end

      def self.down
        drop_table :key_values
      end
    end

Usage
=====

    # set & get
    KeyValue['xxx'] = {:baz=>'foo'})
    KeyValue['xxx'] -> {:baz=>'foo'}

    # delete
    KeyValue['xxx'] = nil
    or KeyValue.del('xxx')

    # increment
    KeyValue.inc('xxx') # !! Not atomic
    or KeyValue.inc('xxx', 5) # increment by 5

    # cache
    result = KeyValue.cache('xxx'){ ..something expensive.. }

    # defaults (in case the value is not stored yet)
    KeyValue.defaults['xxx'] = 1
    KeyValue['xxx'] -> 1
    KeyValue['xxx'] = 2
    KeyValue['xxx'] -> 2
    KeyValue['xxx'] = nil
    KeyValue['xxx'] -> 1

HandlerSocket ([Ubuntu natty guide](http://grosser.it/2011/05/14/installing-mysql-handlersocket-in-ubuntu-natty-for-ruby/)):

    KeyValue.handler_socket = true
    # or Hash with any of these keys :host :port :database :timeout :listen_backlog :sndbuf :rcvbuf

    # all read requests use HandlerSocket
    KeyValue['xxx'] # -> same as before but faster :)

TODO
====
 - HandlerSocket [insert+update](https://github.com/miyucy/handlersocket/blob/master/ext/handler_socket.cc#L364) support
 - Multi-get support `KeyValue.keys('xxx*')` + `KeyValue.multi_get(['xxx1', 'xxx2'])`
 - make test database configurable

Authors
=======
[Roman Heinrich](https://github.com/mindreframer)<br/>
[Michael Grosser](http://grosser.it)<br/>
Hereby placed under public domain, do what you want, just do not hold anyone accountable...
