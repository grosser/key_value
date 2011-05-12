require 'active_record'

class KeyValue < ActiveRecord::Base
  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip
  validates_presence_of :key, :value

  serialize :value

  def self.get(key)
    KeyValue.find_by_key(key).try(:value)
  end

  def self.set(key, value)
    if value
      record = KeyValue.find_by_key(key) || KeyValue.new(:key => key)
      record.value = value
      record.save!
      value
    else
      KeyValue.delete_all(:key => key)
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
    if value
      value
    else
      set(key, yield)
    end
  end
end
