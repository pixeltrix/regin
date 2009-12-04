require 'test_helper'

Spec::Matchers.define :be_parsable do
  match do |actual|
    expression = Reginald.parse(actual)
    expression.should be_a(Reginald::Expression)
    expected = Regexp.compile("\\A#{actual.source}\\Z", actual.options)
    expression.to_regexp.should eql(expected)
  end
end

describe Reginald::Parser do
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
  it { (/abc/n).should be_parsable }
  it { (/^[a-z]*$/).should be_parsable }
  it { (/^[A-Z]*$/).should be_parsable }
  it { (/(.)(.)(.)/).should be_parsable }
  it { (/ab+c/ix).should be_parsable }
  it { (/cat/).should be_parsable }
  it { (/cat/ix).should be_parsable }
  it { Regexp.new('cat', true).should be_parsable }
  it { (/ab+c/ix).should be_parsable }
  it { Regexp.new(/ab+c/ix.to_s).should be_parsable }
end
