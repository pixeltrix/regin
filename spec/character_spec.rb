require 'test_helper'

describe Regin::Character do
  context "with value 'a'" do
    before do
      @character = Regin::Character.new('a')
    end

    it "should have no quantifier" do
      @character.quantifier.should be_nil
    end

    it { @character.should be_literal }

    it "should return a string expression of itself" do
      @character.to_s.should == "a"
    end

    it "should return a regexp of itself" do
      @character.to_regexp.should == /a/
    end

    it "should be inspectable" do
      @character.inspect.should == '#<Character "a">'
    end

    it { @character.should match('a') }
    it { @character.should_not match('b') }

    it { @character.should include('a') }
    it { @character.should_not include('b') }
    it { @character.should_not include('') }

    it "should == another string character" do
      @character.should == 'a'
    end

    it "should == another 'a' character" do
      @character.should == Regin::Character.new('a')
    end

    it "should eql another 'a' character" do
      @character.should eql(Regin::Character.new('a'))
    end

    it "should not == another 'a' character if the quantifier is different" do
      @character.should_not == Regin::Character.new('a', :quantifier => '?')
    end

    it "should not eql another 'a' character if the quantifier is different" do
      @character.should_not eql(Regin::Character.new('a', :quantifier => '?'))
    end

    it "should dup" do
      @character.dup.should == @character
    end

    it "should dup with quantifier" do
      @character.dup(:quantifier => '?').should == Regin::Character.new('a', :quantifier => '?')
    end

    it "should dup with ignorecase" do
      @character.dup(:ignorecase => true).should == Regin::Character.new('a', :ignorecase => true)
    end
  end

  context "with value 'a' and optional quantifier" do
    before do
      @character = Regin::Character.new('a', :quantifier => '?')
    end

    it "should have optional quantifier" do
      @character.quantifier.should == '?'
    end

    it { @character.should_not be_literal }

    it "should return a string expression of itself" do
      @character.to_s.should == 'a?'
    end

    it "should return a regexp of itself" do
      @character.to_regexp.should == /a?/
    end

    it "should be inspectable" do
      @character.inspect.should == '#<Character "a?">'
    end

    it { @character.should match('a') }
    it { @character.should_not match('b') }
    it { @character.should match('') }

    it { @character.should include('a') }
    it { @character.should_not include('b') }
    it { @character.should_not include('') }

    it "should == another string character" do
      @character.should == 'a?'
    end

    it "should == another 'a' character" do
      @character.should == Regin::Character.new('a', :quantifier => '?')
    end

    it "should == another 'a' character if the quantifier is different" do
      @character.should_not == Regin::Character.new('a')
    end
  end

  context "with value 'a' and repeator quantifier" do
    before do
      @character = Regin::Character.new('a', :quantifier => '{2,3}')
    end

    it "should have repeator quantifier" do
      @character.quantifier.should == '{2,3}'
    end

    it { @character.should_not be_literal }

    it "should return a string expression of itself" do
      @character.to_s.should == 'a{2,3}'
    end

    it "should return a regexp of itself" do
      @character.to_regexp.should == /a{2,3}/
    end

    it "should be inspectable" do
      @character.inspect.should == '#<Character "a{2,3}">'
    end

    it { @character.should match('aa') }
    it { @character.should match('aaa') }
    it { @character.should_not match('a') }
    it { @character.should_not match('aaaa') }
    it { @character.should_not match('') }

    it { @character.should include('a') }
    it { @character.should_not include('b') }
  end

  context "with value 'a' and ignorecase" do
    before do
      @character = Regin::Character.new('a', :ignorecase => true)
    end

    it "should have no quantifier" do
      @character.quantifier.should be_nil
    end

    it { @character.should_not be_literal }

    it "should return a string expression of itself" do
      @character.to_s.should == "(?i-mx:a)"
    end

    it "should return a regexp of itself" do
      @character.to_regexp.should == /a/i
    end

    it "should be inspectable" do
      @character.inspect.should == '#<Character "(?i-mx:a)">'
    end

    it { @character.should match('a') }
    it { @character.should match('A') }
    it { @character.should_not match('b') }

    it { @character.should include('a') }
    it { @character.should include('A') }
    it { @character.should_not include('b') }
    it { @character.should_not include('') }
  end

  context "that is frozen" do
    before do
      @character = Regin::Character.new('a', :quantifier => '?')
      @character.freeze
    end

    it { @character.should be_frozen }

    it "value should be frozen" do
      @character.value.should be_frozen
    end

    it "quantifier should be frozen" do
      @character.quantifier.should be_frozen
    end
  end
end
