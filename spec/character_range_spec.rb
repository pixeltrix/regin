require 'test_helper'

describe Reginald::CharacterClass, "from a-z" do
  before do
    # TODO: Character class should be constructed from a set
    # of chars not a string. We should do the parsing
    # in the actual parser, not here.
    @range = Reginald::CharacterClass.new('a-z')
  end

  it "should have no quantifier" do
    @range.quantifier.should be_nil
  end

  it "should not be negated" do
    @range.should_not be_negated
  end

  it "should not be a literal character" do
    @range.should_not be_literal
  end

  it "should return a string expression of itself" do
    @range.to_s.should == "[a-z]"
  end

  it "should return a regexp of itself" do
    @range.to_regexp.should == /\A[a-z]\Z/
  end

  it "should match 'a'" do
    @range.match('a').should be_true
  end

  it "should match 'z'" do
    @range.match('z').should be_true
  end

  it "should not match '1'" do
    @range.match('1').should be_nil
  end

  it "should include 'a'" do
    @range.should include('a')
  end

  it "should not include '1'" do
    @range.should_not include('1')
  end

  it "should == another character with the same value" do
    @range.should == Reginald::CharacterClass.new('a-z')
  end

  it "should eql another character with the same value" do
    @range.should eql(Reginald::CharacterClass.new('a-z'))
  end

  it "should not == another character if the quantifier is different" do
    other_range = Reginald::CharacterClass.new('a-z')
    other_range.quantifier = '?'
    @range.should_not == other_range
  end

  it "should not eql another character if the quantifier is different" do
    other_range = Reginald::CharacterClass.new('a-z')
    other_range.quantifier = '?'
    @range.should_not eql(other_range)
  end

  it "should be freezable" do
    @range.freeze
    @range.should be_frozen
  end
end

describe Reginald::CharacterClass, "from a-z and and repeator quantifier" do
  before do
    @range = Reginald::CharacterClass.new('a-z')

    # TODO: Repeator should be constructed from an integer
    # Range not a string. We should do the parsing
    # in the actual parser, not here.
    @range.quantifier = '{2,3}'
  end

  it "should match 'aa'" do
    @range.match('aa').should be_true
  end

  it "should match 'aaa'" do
    @range.match('aaa').should be_true
  end

  it "should not match 'a'" do
    @range.match('a').should be_nil
  end

  it "should not match '11'" do
    @range.match('11').should be_nil
  end

  it "should include 'a'" do
    @range.should include('a')
  end

  it "should not include '1'" do
    @range.should_not include('1')
  end
end
