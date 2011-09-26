require 'active_record'

class KeyValue < ActiveRecord::Base
  class HandlerSocketError < RuntimeError; end

  HS_DEFAULT_CONFIG = {:port => '9998'}
  HS_INDEX = 31234 # just some high number...
  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip

  cattr_accessor :handler_socket
  cattr_accessor :defaults
  @@defaults = {}.with_indifferent_access

  # serialize would treat false the same as nil
  def value=(x)
    x = x.to_yaml unless x.nil?
    write_attribute :value, x
  end

  def value
    YAML.load(read_attribute :value)
  end

  def self.get(key)
    key = key.to_s

    found = if handler_socket
      open_key_index
      result = hs_find_by_key(key)
      YAML.load(result) if result
    else
      KeyValue.find_by_key(key).try(:value)
    end

    found.nil? ? defaults[key] : found
  end

  def self.set(key, value)
    key = key.to_s

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
      HandlerSocket.new(hs_connection_config)
    end
  end

  def self.hs_connection_config
    given = (handler_socket == true ? {} : handler_socket)
    HS_DEFAULT_CONFIG.merge(connection_pool.spec.config.merge(given))
  end

  def self.open_key_index
    @open_key_index ||= begin
      result = hs_connection.open_index(HS_INDEX, hs_connection_config[:database], table_name, "index_#{table_name}_on_key", 'value')
      raise HandlerSocketError, result[1] if result[0] == -1
    end
  end

  def self.hs_find_by_key(key)
    result = hs_connection.execute_single(HS_INDEX, '=', [key])
    if result[0] == -1
      raise HandlerSocketError, result[1]
    else
      result[1][0].try(:[],0)
    end
  end
end
