require File.expand_path('../spec_helper', __FILE__)

describe KeyValue do
  before do
    KeyValue.handler_socket = false
    KeyValue.delete_all
  end

  it "has a VERSION" do
    KeyValue::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end

  it "can get empty" do
    KeyValue.get('xxx').should == nil
  end

  it "can get empty via []" do
    KeyValue['xxx'].should == nil
  end

  it "can set & get" do
    KeyValue.set('xxx', 1)
    KeyValue.get('xxx').should == 1
  end

  it "can set & get all kinds of objects" do
    KeyValue.set('xxx', '1')
    KeyValue.get('xxx').should == '1'
    KeyValue.delete_all
    KeyValue.set('xxx', [1])
    KeyValue.get('xxx').should == [1]
    KeyValue.delete_all
    KeyValue.set('xxx', {:x => 1})
    KeyValue.get('xxx').should == {:x => 1}
    KeyValue.delete_all
    KeyValue.set('xxx', :x)
    KeyValue.get('xxx').should == :x
  end

  it "can set & get false" do
    KeyValue.set('xxx', false)
    KeyValue.get('xxx').should == false
  end

  it "overwrites on set" do
    KeyValue.set('xxx', 1)
    KeyValue.set('xxx', 2)
    KeyValue.get('xxx').should == 2
  end

  it "returns set value" do
    KeyValue.set('xxx',1).should == 1
  end

  it "can unset" do
    KeyValue.set('yyy', 1)
    KeyValue.set('xxx', 1)
    lambda{
      KeyValue.set('xxx', nil)
    }.should change{KeyValue.count}.by(-1)
    KeyValue.get('xxx').should == nil
  end

  it "can del" do
    KeyValue.set('xxx', 1)
    lambda{
      KeyValue.del('xxx')
    }.should change{KeyValue.count}.by(-1)
    KeyValue.get('xxx').should == nil
  end

  it "can set empty via []=" do
    KeyValue['xxx'] = 1
    KeyValue['xxx'].should == 1
  end

  describe :inc do
    it "can inc on nil" do
      KeyValue.inc('xxx')
      KeyValue['xxx'].should == 1
    end

    it "can inc on existing value" do
      KeyValue['xxx'] = 1
      KeyValue.inc('xxx')
      KeyValue['xxx'].should == 2
    end

    it "can inc with offset" do
      KeyValue.inc('xxx', 5)
      KeyValue['xxx'].should == 5
    end

    it "does not inc on non-numbers" do
      KeyValue['xxx'] = '1'
      lambda{
        KeyValue.inc('xxx')
      }.should raise_error(TypeError)
    end
  end

  describe :cache do
    it "fetches" do
      KeyValue['xxx'] = 1
      KeyValue.cache('xxx'){2}.should == 1
    end

    it "stores" do
      KeyValue.cache('xxx'){2}.should == 2
    end

    it "can store false" do
      KeyValue.cache('xxx'){false}
      KeyValue.cache('xxx'){true}.should == false
    end
  end

  if ENV['DB'] == 'mysql'
    describe 'with handlersocket' do
      before do
        KeyValue.handler_socket = true
        KeyValue.delete_all
      end

      it "can get" do
        KeyValue['xxx'] = '123'
        KeyValue.should_not_receive(:find_by_key)
        KeyValue['xxx'].should == '123'
      end

      it "can get nil" do
        KeyValue['xxx'].should == nil
      end

      it "can get false" do
        KeyValue['xxx'] = false
        KeyValue.should_not_receive(:find_by_key)
        KeyValue['xxx'].should == false
      end

      it "raises on hs error" do
        KeyValue.hs_connection.should_receive(:execute_single).and_return [-1, 'wtf']
        lambda{
          KeyValue['xxx'].should == '123'
        }.should raise_error('wtf')
      end

      it "uses defaults" do
        KeyValue.send(:hs_connection_config).except(:username, :password).should == {
          :flags=>2,
          :port=>"9998",
          :adapter=>"mysql2",
          :database=>"key_values_test"
        }
      end

      it "merges in my given settings" do
        KeyValue.handler_socket = {:port => '123'}
        KeyValue.send(:hs_connection_config).except(:username, :password).should == {
          :flags=>2,
          :port=>"123",
          :adapter=>"mysql2",
          :database=>"key_values_test"
        }

      end
    end
  else
    puts 'not running HandlerSocket specs'
  end
end
