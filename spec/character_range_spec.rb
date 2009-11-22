require 'test_helper'

describe Reginald::CharacterClass do
  shared_examples_for "all range character classes" do
    it { @range.should_not be_literal }
  end

  context "from a-z" do
    before do
      # TODO: Character class should be constructed from a set
      # of chars not a string. We should do the parsing
      # in the actual parser, not here.
      @range = Reginald::CharacterClass.new('a-z')
    end

    it_should_behave_like "all range character classes"

    it "should have no quantifier" do
      @range.quantifier.should be_nil
    end

    it { @range.should_not be_negated }

    it "should return a string expression of itself" do
      @range.to_s.should == "[a-z]"
    end

    it "should return a regexp of itself" do
      @range.to_regexp.should == /\A[a-z]\Z/
    end

    it "should be inspectable" do
      @range.inspect.should == '#<CharacterClass "[a-z]">'
    end

    it { @range.should match('a') }
    it { @range.should match('z') }
    it { @range.should_not match('1') }

    it { @range.should include('a') }
    it { @range.should_not include('1') }

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
  end

  describe "from a-z and and repeator quantifier" do
    before do
      @range = Reginald::CharacterClass.new('a-z')

      # TODO: Repeator should be constructed from an integer
      # Range not a string. We should do the parsing
      # in the actual parser, not here.
      @range.quantifier = '{2,3}'
    end

    it_should_behave_like "all range character classes"

    it { @range.should_not be_negated }

    it "should return a string expression of itself" do
      @range.to_s.should == "[a-z]{2,3}"
    end

    it "should return a regexp of itself" do
      @range.to_regexp.should == /\A[a-z]{2,3}\Z/
    end

    it "should be inspectable" do
      @range.inspect.should == '#<CharacterClass "[a-z]{2,3}">'
    end

    it { @range.should match('aa') }
    it { @range.should match('aaa') }
    it { @range.should_not match('a') }
    it { @range.should_not match('11') }

    it { @range.should include('a') }
    it { @range.should_not include('1') }
  end

  describe "from negated a-z" do
    before do
      @range = Reginald::CharacterClass.new('a-z')
      @range.negate = true
    end

    it_should_behave_like "all range character classes"

    it { @range.should be_negated }

    it "should return a string expression of itself" do
      @range.to_s.should == "[^a-z]"
    end

    it "should return a regexp of itself" do
      @range.to_regexp.should == /\A[^a-z]\Z/
    end

    it "should be inspectable" do
      @range.inspect.should == '#<CharacterClass "[^a-z]">'
    end

    it { @range.should match('1') }
    it { @range.should match('9') }
    it { @range.should_not match('a') }
    it { @range.should_not match('m') }
    it { @range.should_not match('z') }

    it { @range.should include('1') }
    it { @range.should include('9') }
    it { @range.should_not include('a') }
    it { @range.should_not include('m') }
    it { @range.should_not include('z') }
  end

  context "that is frozen" do
    before do
      @range = Reginald::CharacterClass.new('a-z')
      @range.quantifier = '?'
      @range.freeze
    end

    it { @range.should be_frozen }

    it "value should be frozen" do
      @range.value.should be_frozen
    end

    it "quantifier should be frozen" do
      @range.quantifier.should be_frozen
    end
  end
end
