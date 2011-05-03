require 'active_record'

class KeyValue < ActiveRecord::Base
  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip
  validates_presence_of :key, :value

  serialize :value

  def self.get(key)
    KeyValue.find_by_key(key).try(:value)
  end
  alias_method :get, :[]

  def self.set(key, value)
    if value
      record = KeyValue.find_by_key(key) || KeyValue.new(:key => key)
      record.value = value
      record.save!
    else
      KeyValue.delete_all(:key => key)
    end
  end
  alias_method :set, :[]=

  def self.del(key)
    set(key, nil)
  end
end
