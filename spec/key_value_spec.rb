require File.expand_path('spec/spec_helper')

describe KeyValue do
  it "has a VERSION" do
    KeyValue::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end
end
