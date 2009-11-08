require 'reginald'

describe Reginald::CharacterRange do
  before do
    # TODO: Range should be constructed from a set
    # of chars not a string. We should do the parsing
    # in the actual parser, not here.
    @range = Reginald::CharacterRange.new('a-z')
  end

  it "should have no quantifier" do
    @range.quantifier.should be_nil
  end

  it "should not be negated" do
    @range.should_not be_negated
  end

  it "should == another character with the same value" do
    @range.should == Reginald::CharacterRange.new('a-z')
  end

  it "should not == another character if the quantifier is different" do
    other_range = Reginald::CharacterRange.new('a-z')
    other_range.quantifier = '?'
    @range.should_not == other_range
  end

  it "should be freezable" do
    @range.freeze
    @range.should be_frozen
  end
end
