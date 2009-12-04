require 'reginald'

Spec::Matchers.define :parse do |expected|
  match do |actual|
    Reginald.parse(actual).should == expected
  end
end

Spec::Matchers.define :compile do |expected|
  match do |actual|
    Reginald.compile(actual).should == expected
  end
end
