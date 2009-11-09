require 'reginald'

describe Reginald::Character, "with value 'a'" do
  before do
    @character = Reginald::Character.new('a')
  end

  it "can not have a length greater than 1" do
    lambda { Reginald::Character.new('ab') }.should raise_error(ArgumentError)
  end

  it "can not have a length less than 1" do
    lambda { Reginald::Character.new('') }.should raise_error(ArgumentError)
  end

  it "should have no quantifier" do
    @character.quantifier.should be_nil
  end

  it "should be a literal character" do
    @character.should be_literal
  end

  it "should return a string expression of itself" do
    @character.to_s.should == "a"
  end

  it "should return a regexp of itself" do
    @character.to_regexp.should == /\Aa\Z/
  end

  it "should match 'a'" do
    @character.match('a').should be_true
  end

  it "should not match 'b'" do
    @character.match('b').should be_nil
  end

  it "should include 'a'" do
    @character.should include('a')
  end

  it "should not include 'b'" do
    @character.should_not include('b')
  end

  it "should not include empty string" do
    @character.should_not include('')
  end

  it "should == another 'a' character" do
    @character.should == Reginald::Character.new('a')
  end

  it "should eql another 'a' character" do
    @character.should eql(Reginald::Character.new('a'))
  end

  it "should not == another 'a' character if the quantifier is different" do
    other_char = Reginald::Character.new('a')
    other_char.quantifier = '?'
    @character.should_not == other_char
  end

  it "should not eql another 'a' character if the quantifier is different" do
    other_char = Reginald::Character.new('a')
    other_char.quantifier = '?'
    @character.should_not eql(other_char)
  end

  it "should be freezable" do
    @character.freeze
    @character.should be_frozen
  end
end

describe Reginald::Character, "with value 'a' and optional quantifier" do
  before do
    @character = Reginald::Character.new('a')
    @character.quantifier = '?'
  end

  it "should have optional quantifier" do
    @character.quantifier.should == '?'
  end

  it "should not be a literal character" do
    @character.should_not be_literal
  end

  it "should return a string expression of itself" do
    @character.to_s.should == 'a?'
  end

  it "should return a regexp of itself" do
    @character.to_regexp.should == /\Aa?\Z/
  end

  it "should match 'a'" do
    @character.match('a').should be_true
  end

  it "should not match 'b'" do
    @character.match('b').should be_nil
  end

  it "should match empty string" do
    @character.match('').should be_true
  end

  it "should include 'a'" do
    @character.should include('a')
  end

  it "should not include 'b'" do
    @character.should_not include('b')
  end

  it "should not include ''" do
    @character.should_not include('')
  end

  it "should == another 'a' character" do
    other_char = Reginald::Character.new('a')
    other_char.quantifier = '?'
    @character.should == other_char
  end

  it "should == another 'a' character if the quantifier is different" do
    @character.should_not == Reginald::Character.new('a')
  end
end

describe Reginald::Character, "with value 'a' and repeator quantifier" do
  before do
    @character = Reginald::Character.new('a')

    # TODO: Repeator should be constructed from an integer
    # Range not a string. We should do the parsing
    # in the actual parser, not here.
    @character.quantifier = '{2,3}'
  end

  it "should have repeator quantifier" do
    @character.quantifier.should == '{2,3}'
  end

  it "should not be a literal character" do
    @character.should_not be_literal
  end

  it "should return a string expression of itself" do
    @character.to_s.should == 'a{2,3}'
  end

  it "should return a regexp of itself" do
    @character.to_regexp.should == /\Aa{2,3}\Z/
  end

  it "should match 'aa'" do
    @character.match('aa').should be_true
  end

  it "should match 'aaa'" do
    @character.match('aaa').should be_true
  end

  it "should not match 'a'" do
    @character.match('a').should be_nil
  end

  it "should not match 'aaaa'" do
    @character.match('aaaa').should be_nil
  end

  it "should not match empty string" do
    @character.match('').should be_nil
  end

  it "should include 'a'" do
    @character.should include('a')
  end

  it "should not include 'b'" do
    @character.should_not include('b')
  end

  it "should be freezable" do
    @character.freeze
    @character.should be_frozen
    @character.quantifier.should be_frozen
  end
end
