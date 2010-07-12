require 'test_helper'

describe Regin::CharacterClass do
  shared_examples_for "all range character classes" do
    it { @range.should_not be_literal }
  end

  context "from a-z" do
    before do
      # TODO: Character class should be constructed from a set
      # of chars not a string. We should do the parsing
      # in the actual parser, not here.
      @range = Regin::CharacterClass.new('a-z')
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
      @range.to_regexp.should == /[a-z]/
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
      @range.should == Regin::CharacterClass.new('a-z')
    end

    it "should eql another character with the same value" do
      @range.should eql(Regin::CharacterClass.new('a-z'))
    end

    it "should not == another character if the quantifier is different" do
      @range.should_not == Regin::CharacterClass.new('a-z', :quantifier => '?')
    end

    it "should not eql another character if the quantifier is different" do
      @range.should_not eql(Regin::CharacterClass.new('a-z', :quantifier => '?'))
    end

    it "should dup" do
      @range.dup.should == @range
    end

    it "should dup with quantifier" do
      @range.dup(:quantifier => '?').should == Regin::CharacterClass.new('a-z', :quantifier => '?')
    end

    it "should dup with ignorecase" do
      @range.dup(:ignorecase => true).should == Regin::CharacterClass.new('a-z', :ignorecase => true)
    end

    it "should dup with negate" do
      @range.dup(:negate => true).should == Regin::CharacterClass.new('a-z', :negate => true)
    end
  end

  context "from '.'" do
    before do
      @range = Regin::CharacterClass.new('.')
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
      @range.to_regexp.should == /./
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
      @range.should == Regin::CharacterClass.new('.')
    end

    it "should eql another character with the same value" do
      @range.should eql(Regin::CharacterClass.new('.'))
    end

    it "should not == another character if the quantifier is different" do
      @range.should_not == Regin::CharacterClass.new('.', :quantifier => '?')
    end

    it "should not eql another character if the quantifier is different" do
      @range.should_not eql(Regin::CharacterClass.new('.', :quantifier => '?'))
    end
  end

  context "from a-z and and repeator quantifier" do
    before do
      @range = Regin::CharacterClass.new('a-z', :quantifier => '{2,3}')
    end

    it_should_behave_like "all range character classes"

    it { @range.should_not be_negated }

    it "should return a string expression of itself" do
      @range.to_s.should == "[a-z]{2,3}"
    end

    it "should return a regexp of itself" do
      @range.to_regexp.should == /[a-z]{2,3}/
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
      @range = Regin::CharacterClass.new('a-z', :negate => true)
    end

    it_should_behave_like "all range character classes"

    it { @range.should be_negated }

    it "should return a string expression of itself" do
      @range.to_s.should == "[^a-z]"
    end

    it "should return a regexp of itself" do
      @range.to_regexp.should == /[^a-z]/
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
      @range = Regin::CharacterClass.new('a-z', :ignorecase => true)
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
      @range.to_regexp.should == /[a-z]/i
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
      @range = Regin::CharacterClass.new('.', :ignorecase => true)
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
      @range.to_regexp.should == /./i
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
end
