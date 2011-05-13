require 'active_record'

class KeyValue < ActiveRecord::Base
  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip
  validates_presence_of :key

  serialize :value

  # serialize would treat false the same as nil
  def value=(x)
    x = x.to_yaml unless x.nil?
    write_attribute :value, x
  end

  def self.get(key)
    KeyValue.find_by_key(key).try(:value)
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
end
