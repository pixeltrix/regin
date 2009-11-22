require 'test_helper'

describe Reginald::Parser do
  it "should compile simple regexp string" do
    'foo(bar)?'.should compile(/foo(bar)?/)
  end

  it "should recompile simple regexp" do
    /foo(bar)?/.should compile(/foo(bar)?/)
  end

  it "should simplify top level inline options" do
    /(?-mix:foo)/.should compile(/(?:foo)/)
  end
end
