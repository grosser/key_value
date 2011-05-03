require File.expand_path('spec/spec_helper')

describe KeyValue do
  before do
    KeyValue.delete_all
  end

  it "has a VERSION" do
    KeyValue::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end

  it "can get empty" do
    KeyValue.get('xxx').should == nil
  end

  it "can set & get" do
    KeyValue.set('xxx', 1)
    KeyValue.get('xxx').should == 1
  end

  it "overwrites on set" do
    KeyValue.set('xxx', 1)
    KeyValue.set('xxx', 2)
    KeyValue.get('xxx').should == 2
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
end
