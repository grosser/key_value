require 'active_record'

class KeyValue < ActiveRecord::Base
  HS_DEFAULT_CONFIG = {:port => '9998'}
  HS_INDEX = 31234 # just some high number...
  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip

  set_primary_key :key
  serialize :value

  cattr_accessor :handler_socket

  # serialize would treat false the same as nil
  def value=(x)
    x = x.to_yaml unless x.nil?
    write_attribute :value, x
  end

  def self.get(key)
    if handler_socket
      open_key_index
      result = hs_connection.execute_single(HS_INDEX, '=', [key])
      return unless result = result[1][0]
      YAML.load(result[0])
    else
      KeyValue.find_by_key(key).try(:value)
    end
  end

  def self.set(key, value)
    if value.nil?
      KeyValue.delete_all(:key => key)
    else
      unless record = KeyValue.find_by_key(key)
        record = KeyValue.new
        record.key = key # no mass assignment on primary key
      end
      record.value = value
      record.save!
      value
    end
  end

  class << self
    alias_method :[], :get
    alias_method :[]=, :set
  end

  def self.del(key)
    set(key, nil)
  end

  def self.inc(key, offset=1)
    set(key, (get(key) || 0) + offset)
  end

  def self.cache(key)
    value = get(key)
    if value.nil?
      set(key, yield)
    else
      value
    end
  end

  private

  def self.hs_connection
    @hs_connection ||= begin
      require 'handlersocket'
      HandlerSocket.new(HS_DEFAULT_CONFIG.merge(handler_socket))
    end
  end

  def self.hs_connection_config
    HS_DEFAULT_CONFIG.merge(connection_pool.spec.config.merge(handler_socket))
  end

  def self.open_key_index
    @open_key_index ||= hs_connection.open_index(HS_INDEX, handler_socket[:database], table_name, "index_#{table_name}_on_key", 'value')
  end
end
