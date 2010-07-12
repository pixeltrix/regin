require 'regin'

Spec::Matchers.define :parse do |expected|
  match do |actual|
    Regin.parse(actual).should == expected
  end
end

Spec::Matchers.define :compile do |expected|
  match do |actual|
    Regin.compile(actual).should == expected
  end
end
