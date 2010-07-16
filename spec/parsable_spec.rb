require 'test_helper'

Spec::Matchers.define :be_parsable do
  match do |actual|
    expression = Regin.parse(actual)
    expression.should be_a(Regin::Expression)
    expected = Regexp.compile(actual.source, actual.options)
    expression.to_regexp.should eql(expected)
  end
end

InvalidRegexp = Struct.new(:source, :options)

Spec::Matchers.define :not_be_parsable do
  match do |actual|
    lambda { Regexp.compile(actual) }.should raise_error(RegexpError)
    invalid_regexp = InvalidRegexp.new(actual, 0)
    lambda { Regin.parse(Regin.parse(invalid_regexp)) }.should raise_error(Racc::ParseError)
  end
end

describe Regin::Parser do
  it { %r{foo}.should be_parsable }
  it { %r{foo(bar)}.should be_parsable }
  it { %r{foo(bar(baz))}.should be_parsable }

  # Examples from http://www.ruby-doc.org/core/classes/Regexp.html
  it { (/c(.)t/).should be_parsable }
  it { Regexp.new('^a-z+:\\s+\w+').should be_parsable }
  it { Regexp.new('cat', true).should be_parsable }
  it { Regexp.new('dog', Regexp::EXTENDED).should be_parsable }
  it { Regexp.union("penzance").should be_parsable }
  it { Regexp.union("skiing", "sledding").should be_parsable }
  it { Regexp.union(/dogs/i, /cats/i).should be_parsable }
  it { Regexp.union("skiing", "sledding").should be_parsable }
  it { (/abc/).should be_parsable }
  it { (/abc/x).should be_parsable }
  it { (/abc/i).should be_parsable }
  it { (/^[a-z]*$/).should be_parsable }
  it { (/^[A-Z]*$/).should be_parsable }
  it { (/(.)(.)(.)/).should be_parsable }
  it { (/ab+c/ix).should be_parsable }
  it { (/cat/).should be_parsable }
  it { (/cat/ix).should be_parsable }
  it { Regexp.new('cat', true).should be_parsable }
  it { (/ab+c/ix).should be_parsable }
  it { Regexp.new(/ab+c/ix.to_s).should be_parsable }

  it { '+?'.should not_be_parsable }
  it { '*?'.should not_be_parsable }

  it { %r{a{3}}.should be_parsable }
  it { %r{a{2,4}}.should be_parsable }
  it { %r{a{1,23}}.should be_parsable }
  it { %r{a{1,23}}.should be_parsable }
  it { %r{a{1,234}}.should be_parsable }
  it { %r{a{12,34}}.should be_parsable }
  it { %r{a{0,}}.should be_parsable }
  it { %r{a{1,}}.should be_parsable }
  # it { 'a{2,1}'.should not_be_parsable }
end
