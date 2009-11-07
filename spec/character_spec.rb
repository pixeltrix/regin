require 'reginald'

describe Reginald::Character do
  before do
    @character = Reginald::Character.new('a')
  end

  it "should have no quantifier" do
    @character.quantifier.should be_nil
  end

  it "should return a string expression of itself" do
    @character.to_s.should == "a"
  end

  it "should == another character with the same value" do
    @character.should == Reginald::Character.new('a')
  end

  it "should == another character if the quantifier is different" do
    other_char = Reginald::Character.new('a')
    other_char.quantifier = '?'
    @character.should_not == other_char
  end

  it "should be freezable" do
    @character.freeze
    @character.should be_frozen
  end
end
