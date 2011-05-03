class KeyValue < ActiveRecord::Base
 VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip

 serialize :value

 def self.get(keyname)
   record = KeyValue.find_by_key(key)
   record ? record.value : nil
 end

 def self.set(key, value)
   if value
     record = KeyValue.find_by_key(key)
     if record
       record.value = value
     else
       record = KeyValue.new(:key => key, :value => value)
     end
     record.save
   else
      KeyValue.delete_all(:key => key)
   end
 end
end
