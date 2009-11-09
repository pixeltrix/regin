require 'reginald'

describe Reginald::Group, "with capture" do
  before do
    @expression = Reginald::Expression.new([
      Reginald::Character.new('f'),
      Reginald::Character.new('o'),
      Reginald::Character.new('o')
    ])
    @group = Reginald::Group.new(@expression)
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
    @group.to_regexp.should == /\A(foo)\Z/
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

  it "should be freezable" do
    @group.freeze
    @group.should be_frozen
  end
end
