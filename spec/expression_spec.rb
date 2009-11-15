require 'reginald'

describe Reginald::Expression, "with capture" do
  before do
    @expression = Reginald::Expression.new(
      Reginald::Character.new('f'),
      Reginald::Character.new('o'),
      Reginald::Character.new('o')
    )
  end

  it "should be a literal expression" do
    @expression.should be_literal
  end

  it "should return a string expression of itself" do
    @expression.to_s.should == "foo"
  end

  it "should return a regexp of itself" do
    @expression.to_regexp.should == /\Afoo\Z/
  end

  it "should have no options" do
    @expression.options.should == 0
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
    @expression.freeze
    @expression.should be_frozen
    @expression.each { |child| child.should be_frozen }
  end
end

describe Reginald::Expression, "initialize with array" do
  before do
    @expression = Reginald::Expression.new([
      Reginald::Character.new('f'),
      Reginald::Character.new('o'),
      Reginald::Character.new('o')
    ])
  end

  it "should have 3 children" do
    @expression.size.should == 3
  end
end

describe Reginald::Expression, "initialize with args" do
  before do
    @expression = Reginald::Expression.new(
      Reginald::Character.new('f'),
      Reginald::Character.new('o'),
      Reginald::Character.new('o')
    )
  end

  it "should have 3 children" do
    @expression.size.should == 3
  end
end

describe Reginald::Expression, "with ignorecase" do
  before do
    @expression = Reginald::Expression.new(
      Reginald::Character.new('f'),
      Reginald::Character.new('o'),
      Reginald::Character.new('o')
    )
    @expression.ignorecase = true
  end

  it "should be a literal expression" do
    @expression.should_not be_literal
  end

  it "should return a string expression of itself" do
    @expression.to_s.should == "(?i-mx:foo)"
  end

  it "should return a regexp of itself" do
    @expression.to_regexp.should == /\Afoo\Z/i
  end

  it "should have ignorecase option" do
    @expression.options.should == Regexp::IGNORECASE
  end
end
