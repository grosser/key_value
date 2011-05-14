require 'active_record'

class KeyValue < ActiveRecord::Base
  HS_DEFAULT_CONFIG = {:host => '127.0.0.1', :port => '9998'}
  HS_INDEX = 31234 # just some high number...
  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip
  validates_presence_of :key

  serialize :value

  cattr_accessor :handler_socket

  # serialize would treat false the same as nil
  def value=(x)
    x = x.to_yaml unless x.nil?
    write_attribute :value, x
  end

  def self.get(key)
    if handler_socket
      hs_connection.open_index(HS_INDEX, 'key_values_test', 'key_values', 'index_key_values_on_key', 'value')
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
      record = KeyValue.find_by_key(key) || KeyValue.new(:key => key)
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
    @@hs_connection ||= begin
      require 'handlersocket'
      config = (handler_socket == true ? HS_DEFAULT_CONFIG : handler_socket)
      HandlerSocket.new(config)
    end
  end
end
