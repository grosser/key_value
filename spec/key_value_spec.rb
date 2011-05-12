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

  it "can get empty via []" do
    KeyValue['xxx'].should == nil
  end

  it "can set & get" do
    KeyValue.set('xxx', 1)
    KeyValue.get('xxx').should == 1
  end

  it "can set & get false" do
    pending
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
      pending
      KeyValue.cache('xxx'){false}
      KeyValue.cache('xxx'){true}.should == false
    end
  end
end
