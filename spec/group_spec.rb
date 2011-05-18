require 'test_helper'

describe Regin::Group, "with capture" do
  before do
    @expression = Regin::Expression.new(
      Regin::Character.new('f'),
      Regin::Character.new('o'),
      Regin::Character.new('o')
    )
    @group = Regin::Group.new(@expression)
  end

  it "should have no quantifier" do
    @group.quantifier.should be_nil
  end

  it "should be a capture" do
    @group.should be_capture
  end

  it "should have no name" do
    @group.name.should be_nil
  end

  it "should be a literal expression" do
    @group.should be_literal
  end

  it "should return a string expression of itself" do
    @group.to_s.should == "(foo)"
  end

  it "should return a regexp of itself" do
    @group.to_regexp.should == /(foo)/
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
    @group.dup.should == @group
  end

  it "should dup with ignorecase" do
    @group.dup(:ignorecase => true).should == Regin::Group.new(Regin::Expression.new(
      Regin::Character.new('f'),
      Regin::Character.new('o'),
      Regin::Character.new('o')), :ignorecase => true)
  end

  it "should dup with ignorecase" do
    @group.dup(:quantifier => '?').should == Regin::Group.new(Regin::Expression.new(
      Regin::Character.new('f'),
      Regin::Character.new('o'),
      Regin::Character.new('o')), :quantifier => '?')
  end
end

describe Regin::Group, "with ignorecase capture expression" do
  before do
    @expression = Regin::Expression.new(
      Regin::Character.new('f'),
      Regin::Character.new('o'),
      Regin::Character.new('o'),
      :ignorecase => true
    )
    @group = Regin::Group.new(@expression)
  end

  it "should have no quantifier" do
    @group.quantifier.should be_nil
  end

  it "should be a capture" do
    @group.should be_capture
  end

  it "should have no name" do
    @group.name.should be_nil
  end

  it "should not be a literal expression" do
    @group.should_not be_literal
  end

  it "should return a string expression of itself" do
    @group.to_s.should == "((?i-mx:foo))"
  end

  it "should return a regexp of itself" do
    @group.to_regexp.should == /((?i-mx:foo))/
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
end

describe Regin::Group, "with ignorecase optional capture expression" do
  before do
    @expression = Regin::Expression.new(
      Regin::Character.new('f'),
      Regin::Character.new('o'),
      Regin::Character.new('o'),
      :ignorecase => true
    )
    @group = Regin::Group.new(@expression, :quantifier => '?')
  end

  it "should have optional quantifier" do
    @group.quantifier.should == '?'
  end

  it "should be a capture" do
    @group.should be_capture
  end

  it "should have no name" do
    @group.name.should be_nil
  end

  it "should not be a literal expression" do
    @group.should_not be_literal
  end

  it "should return a string expression of itself" do
    @group.to_s.should == "((?i-mx:foo))?"
  end

  it "should return a regexp of itself" do
    @group.to_regexp.should == /((?i-mx:foo))?/
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
end

describe Regin::Group, "with postive look-ahead" do
  before do
    @expression = Regin::Expression.new(Regin::Character.new('a'))
    @group = Regin::Group.new(@expression, :lookahead => :postive)
  end

  it "should not be a literal expression" do
    @group.should_not be_literal
  end

  it "should return a string expression of itself" do
    @group.to_s.should == "(?=a)"
  end

  it "should return a regexp of itself" do
    @group.to_regexp.should == /(?=a)/
  end

  it "should match 'a'" do
    @expression.match('a').should be_true
  end

  it "should not match 'b'" do
    @expression.match('b').should be_nil
  end

  it "should include 'a'" do
    @expression.should include('a')
  end

  it "should not include 'b'" do
    @expression.should_not include('b')
  end
end

describe Regin::Group, "with negative look-ahead" do
  before do
    @expression = Regin::Expression.new(Regin::Character.new('a'))
    @group = Regin::Group.new(@expression, :lookahead => :negative)
  end

  it "should not be a literal expression" do
    @group.should_not be_literal
  end

  it "should return a string expression of itself" do
    @group.to_s.should == "(?!a)"
  end

  it "should return a regexp of itself" do
    @group.to_regexp.should == /(?!a)/
  end

  it "should match 'a'" do
    @expression.match('a').should be_true
  end

  it "should match 'b'" do
    @expression.match('b').should be_nil
  end

  it "should include 'a'" do
    @expression.should include('a')
  end

  it "should include 'b'" do
    @expression.should_not include('b')
  end
end
