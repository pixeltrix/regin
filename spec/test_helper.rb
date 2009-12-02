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

Spec::Matchers.define :be_parsable do
  match do |actual|
    expression = Reginald.parse(actual)
    expression.should be_a(Reginald::Expression)
    expression.to_regexp.should eql(/\A#{actual.source}\Z/)
  end
end
