require 'reginald'

describe Reginald::Character do
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

  it "should return a string expression of itself" do
    @character.to_s.should == "a"
  end

  it "should return a regexp of itself" do
    @character.to_regexp.should == /\Aa\Z/
  end

  it "should match character" do
    @character.match('a').should be_true
  end

  it "should not match character" do
    @character.match('b').should be_nil
  end

  it "should not match no characters" do
    @character.match('').should be_nil
  end

  it "should include character" do
    @character.should include('a')
  end

  it "should not include character" do
    @character.should_not include('b')
  end

  it "should == another character with the same value" do
    @character.should == Reginald::Character.new('a')
  end

  it "should return a set of characters" do
    @character.to_set.should == Set.new(['a'])
  end

  it "should not == another character if the quantifier is different" do
    other_char = Reginald::Character.new('a')
    other_char.quantifier = '?'
    @character.should_not == other_char
  end

  it "should be freezable" do
    @character.freeze
    @character.should be_frozen
  end
end


describe Reginald::Character, "with optional quantifier" do
  before do
    @character = Reginald::Character.new('a')
    @character.quantifier = '?'
  end

  it "should have no quantifier" do
    @character.quantifier.should == '?'
  end

  it "should return a string expression of itself" do
    @character.to_s.should == 'a?'
  end

  it "should return a regexp of itself" do
    @character.to_regexp.should == /\Aa?\Z/
  end

  it "should match character" do
    @character.match('a').should be_true
  end

  it "should not match character" do
    @character.match('b').should be_nil
  end

  it "should match no characters" do
    @character.match('').should be_true
  end

  it "should include character" do
    @character.should include('a')
  end

  it "should not include character" do
    @character.should_not include('b')
  end

  it "should == another character with the same value" do
    other_char = Reginald::Character.new('a')
    other_char.quantifier = '?'
    @character.should == other_char
  end

  it "should == another character if the quantifier is different" do
    @character.should_not == Reginald::Character.new('a')
  end
end
