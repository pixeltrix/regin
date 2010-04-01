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

  context "from '.'" do
    before do
      @range = Reginald::CharacterClass.new('.')
    end

    it_should_behave_like "all range character classes"

    it "should have no quantifier" do
      @range.quantifier.should be_nil
    end

    it { @range.should_not be_negated }
    it { @range.should_not be_casefold }

    it "should return a string expression of itself" do
      @range.to_s.should == "."
    end

    it "should return a regexp of itself" do
      @range.to_regexp.should == /\A.\Z/
    end

    it "should be inspectable" do
      @range.inspect.should == '#<CharacterClass ".">'
    end

    it { @range.should match('a') }
    it { @range.should match('z') }
    it { @range.should match('1') }

    it { @range.should include('a') }
    it { @range.should include('1') }

    it "should == another character with the same value" do
      @range.should == Reginald::CharacterClass.new('.')
    end

    it "should eql another character with the same value" do
      @range.should eql(Reginald::CharacterClass.new('.'))
    end

    it "should not == another character if the quantifier is different" do
      other_range = Reginald::CharacterClass.new('.')
      other_range.quantifier = '?'
      @range.should_not == other_range
    end

    it "should not eql another character if the quantifier is different" do
      other_range = Reginald::CharacterClass.new('.')
      other_range.quantifier = '?'
      @range.should_not eql(other_range)
    end
  end

  context "from a-z and and repeator quantifier" do
    before do
      @range = Reginald::CharacterClass.new('a-z', :quantifier => '{2,3}')
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

  context "from negated a-z" do
    before do
      @range = Reginald::CharacterClass.new('a-z', :negate => true)
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

  context "from a-z and ignorecase" do
    before do
      # TODO: Character class should be constructed from a set
      # of chars not a string. We should do the parsing
      # in the actual parser, not here.
      @range = Reginald::CharacterClass.new('a-z', :ignorecase => true)
    end

    it_should_behave_like "all range character classes"

    it "should have no quantifier" do
      @range.quantifier.should be_nil
    end

    it { @range.should_not be_negated }
    it { @range.should be_casefold }

    it "should return a string expression of itself" do
      @range.to_s.should == "(?i-mx:[a-z])"
    end

    it "should return a regexp of itself" do
      @range.to_regexp.should == /\A[a-z]\Z/i
    end

    it "should be inspectable" do
      @range.inspect.should == '#<CharacterClass "(?i-mx:[a-z])">'
    end

    it { @range.should match('a') }
    it { @range.should match('A') }
    it { @range.should match('z') }
    it { @range.should match('Z') }
    it { @range.should_not match('1') }

    it { @range.should include('a') }
    it { @range.should include('A') }
    it { @range.should_not include('1') }
  end

  context "from '.' and ignorecase" do
    before do
      @range = Reginald::CharacterClass.new('.', :ignorecase => true)
    end

    it_should_behave_like "all range character classes"

    it "should have no quantifier" do
      @range.quantifier.should be_nil
    end

    it { @range.should_not be_negated }
    it { @range.should be_casefold }

    it "should return a string expression of itself" do
      @range.to_s.should == "(?i-mx:.)"
    end

    it "should return a regexp of itself" do
      @range.to_regexp.should == /\A.\Z/i
    end

    it "should be inspectable" do
      @range.inspect.should == '#<CharacterClass "(?i-mx:.)">'
    end

    it { @range.should match('a') }
    it { @range.should match('z') }
    it { @range.should match('1') }

    it { @range.should include('a') }
    it { @range.should include('1') }
  end

  context "that is frozen" do
    before do
      @range = Reginald::CharacterClass.new('a-z', :quantifier => '?')
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
