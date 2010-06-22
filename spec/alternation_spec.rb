require 'test_helper'

describe Regin::Alternation do
  context "a|b|c" do
    before do
      @alternation = Regin::Alternation.new(
        Regin::Expression.new(Regin::Character.new('a')),
        Regin::Expression.new(Regin::Character.new('b')),
        Regin::Expression.new(Regin::Character.new('c'))
      )
    end

    it "should not be a literal expression" do
      @alternation.should_not be_literal
    end

    it "should return a string expression of itself" do
      @alternation.to_s.should == 'a|b|c'
    end

    it "should return a regexp of itself" do
      @alternation.to_regexp.should == /\Aa|b|c\Z/
    end

    it "should match 'a'" do
      @alternation.match('a').should be_true
    end

    it "should match 'b'" do
      @alternation.match('b').should be_true
    end

    it "should match 'c'" do
      @alternation.match('c').should be_true
    end

    it "should not match 'z'" do
      @alternation.match('z').should be_nil
    end

    it "should include 'a'" do
      @alternation.should include('a')
    end

    it "should include 'b'" do
      @alternation.should include('b')
    end

    it "should include 'c'" do
      @alternation.should include('c')
    end

    it "should not include 'z'" do
      @alternation.should_not include('z')
    end

    it "should be freezable" do
      @alternation.freeze
      @alternation.should be_frozen
      @alternation.each { |child| child.should be_frozen }
    end

    it "should dup" do
      @alternation.dup.should == @alternation
    end

    it "should dup with ignorecase" do
      @alternation.dup(:ignorecase => true).should == Regin::Alternation.new(
        Regin::Expression.new(Regin::Character.new('a')),
        Regin::Expression.new(Regin::Character.new('b')),
        Regin::Expression.new(Regin::Character.new('c')),
        :ignorecase => true
      )
    end

    it "should dup with ignorecase and apply to children" do
      @alternation.dup(:ignorecase => true).first.should == Regin::Expression.new(Regin::Character.new('a', :ignorecase => true), :ignorecase => true)
    end
  end

  context "case insensitive a|b|c" do
    before do
      @alternation = Regin::Alternation.new(
        Regin::Expression.new(Regin::Character.new('a')),
        Regin::Expression.new(Regin::Character.new('b')),
        Regin::Expression.new(Regin::Character.new('c')),
        :ignorecase => true
      )
    end

    it "should not be a literal expression" do
      @alternation.should_not be_literal
    end

    it "should return a string expression of itself" do
      @alternation.to_s.should == '(?i-mx:a)|(?i-mx:b)|(?i-mx:c)'
    end

    it "should return a regexp of itself" do
      @alternation.to_regexp.should == /\Aa|b|c\Z/
    end

    it "should apply ignorecase to child expression" do
      @alternation.first.should be_casefold
    end

    it "should apply ignorecase to child characters" do
      @alternation.first.first.should be_casefold
    end

    it "should dup" do
      @alternation.dup.should == @alternation
    end
  end
end
