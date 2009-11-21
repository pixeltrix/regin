require 'reginald'

Spec::Matchers.define :parse do |expected|
  match do |actual|
    Reginald.parse(actual).should == expected
  end
end
