require 'test_helper'

describe Regin::Expression, "with capture" do
  before do
    @expression = Regin::Expression.new(
      Regin::Character.new('f'),
      Regin::Character.new('o'),
      Regin::Character.new('o')
    )
  end

  it "should be a literal expression" do
    @expression.should be_literal
  end

  it "should return a string expression of itself" do
    @expression.to_s.should == "foo"
  end

  it "should return a regexp of itself" do
    @expression.to_regexp.should == /foo/
  end

  it "should have no flags" do
    @expression.flags.should == 0
  end

  it "should not have options" do
    @expression.should_not be_options
  end

  it "should match 'foo'" do
    @expression.match('foo').should be_true
  end

  it "should not match 'bar'" do
    @expression.match('bar').should be_nil
  end

  it "should include 'f'" do
    @expression.should include('f')
  end

  it "should include 'o'" do
    @expression.should include('f')
  end

  it "should not include 'b'" do
    @expression.should_not include('b')
  end

  it "should dup" do
    @expression.dup.should == @expression
  end

  it "should dup with ignorecase" do
    @expression.dup(:ignorecase => true).should == Regin::Expression.new(
      Regin::Character.new('f'),
      Regin::Character.new('o'),
      Regin::Character.new('o'),
      :ignorecase => true
    )
  end

  it "should dup with ignorecase and apply to children" do
    @expression.dup(:ignorecase => true).first.should == Regin::Character.new('f', :ignorecase => true)
  end

  it "should + with other expression" do
    expression = @expression + Regin::Expression.new(
      Regin::Character.new('b'),
      Regin::Character.new('a'),
      Regin::Character.new('r')
    )

    expression.should == Regin::Expression.new(
      Regin::Character.new('f'),
      Regin::Character.new('o'),
      Regin::Character.new('o'),
      Regin::Character.new('b'),
      Regin::Character.new('a'),
      Regin::Character.new('r')
    )
  end

  it "should + with other array" do
    expression = @expression + [
      Regin::Character.new('b'),
      Regin::Character.new('a'),
      Regin::Character.new('r')
    ]

    expression.should == Regin::Expression.new(
      Regin::Character.new('f'),
      Regin::Character.new('o'),
      Regin::Character.new('o'),
      Regin::Character.new('b'),
      Regin::Character.new('a'),
      Regin::Character.new('r')
    )
  end

  it "should not + with other class" do
    lambda { @expression + Regin::Alternation.new }.should raise_error(TypeError)
  end

  it "should add case insensitive atoms" do
    expression = @expression + [
      Regin::Character.new('b', :ignorecase => true),
      Regin::Character.new('a', :ignorecase => true),
      Regin::Character.new('r', :ignorecase => true)
    ]

    expression.should == Regin::Expression.new(
      Regin::Character.new('f'),
      Regin::Character.new('o'),
      Regin::Character.new('o'),
      Regin::Character.new('b', :ignorecase => true),
      Regin::Character.new('a', :ignorecase => true),
      Regin::Character.new('r', :ignorecase => true)
    )
  end
end

describe Regin::Expression, "initialize with array" do
  before do
    @expression = Regin::Expression.new([
      Regin::Character.new('f'),
      Regin::Character.new('o'),
      Regin::Character.new('o')
    ])
  end

  it "should have 3 children" do
    @expression.size.should == 3
  end
end

describe Regin::Expression, "initialize with args" do
  before do
    @expression = Regin::Expression.new(
      Regin::Character.new('f'),
      Regin::Character.new('o'),
      Regin::Character.new('o')
    )
  end

  it "should have 3 children" do
    @expression.size.should == 3
  end
end

describe Regin::Expression, "with ignorecase" do
  before do
    @expression = Regin::Expression.new(
      Regin::Character.new('f'),
      Regin::Character.new('o'),
      Regin::Character.new('o'),
      :ignorecase => true
    )
  end

  it "should be a literal expression" do
    @expression.should_not be_literal
  end

  it "should return a string expression of itself" do
    @expression.to_s.should == "(?i-mx:foo)"
  end

  it "should return a regexp of itself" do
    @expression.to_regexp.should == /foo/i
  end

  it "should have ignorecase flag" do
    @expression.flags.should == Regexp::IGNORECASE
  end

  it "should apply ignorecase to child characters" do
    @expression.first.should be_casefold
  end

  it "should have options" do
    @expression.should be_options
  end

  it "should dup" do
    @expression.dup.should == @expression
  end

  it "should dup but not reset ignorecase" do
    @expression.dup(:ignorecase => nil).should == Regin::Expression.new(
      Regin::Character.new('f'),
      Regin::Character.new('o'),
      Regin::Character.new('o'),
      :ignorecase => true
    )
  end

  it "should dup but not disable ignorecase" do
    @expression.dup(:ignorecase => false).should == Regin::Expression.new(
      Regin::Character.new('f'),
      Regin::Character.new('o'),
      Regin::Character.new('o'),
      :ignorecase => true
    )
  end

  it "should + with other expression" do
    expression = @expression + Regin::Expression.new(
      Regin::Character.new('b'),
      Regin::Character.new('a'),
      Regin::Character.new('r')
    )

    expression.should == Regin::Expression.new(
      Regin::Character.new('f'),
      Regin::Character.new('o'),
      Regin::Character.new('o'),
      Regin::Character.new('b'),
      Regin::Character.new('a'),
      Regin::Character.new('r'),
      :ignorecase => true
    )
  end
end

describe Regin::Expression, "with explicit case" do
  before do
    @expression = Regin::Expression.new(
      Regin::Character.new('f'),
      Regin::Character.new('o'),
      Regin::Character.new('o'),
      :ignorecase => false
    )
  end

  it "should be a literal expression" do
    @expression.should be_literal
  end

  it "should return a string expression of itself" do
    @expression.to_s.should == "(?-mix:foo)"
  end

  it "should return a regexp of itself" do
    @expression.to_regexp.should == /foo/
  end

  it "should have ignorecase flag" do
    @expression.flags.should == 0
  end

  it "should have options" do
    @expression.should be_options
  end

  it "should + with other expression" do
    expression = @expression + Regin::Expression.new(
      Regin::Character.new('b'),
      Regin::Character.new('a'),
      Regin::Character.new('r')
    )

    expression.should == Regin::Expression.new(
      Regin::Character.new('f'),
      Regin::Character.new('o'),
      Regin::Character.new('o'),
      Regin::Character.new('b'),
      Regin::Character.new('a'),
      Regin::Character.new('r'),
      :ignorecase => false
    )
  end
end
