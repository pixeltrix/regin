require 'regin'

RSpec::Matchers.define :parse do |expected|
  match do |actual|
    Regin.parse(actual).should == expected
  end
end

RSpec::Matchers.define :compile do |expected|
  match do |actual|
    Regin.compile(actual).should == expected
  end
end
