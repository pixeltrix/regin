require 'test_helper'

describe Reginald::Parser do
  it "should parse slashes" do
    /\//.should parse(expr(char('/')))
    %r{/}.should parse(expr(char('/')))
    %r{\/}.should parse(expr(char('/')))
  end

  it "should parse escaped specials" do
    %r{\^}.should parse(expr(char('^')))
    %r{\.}.should parse(expr(char('.')))
    %r{\[}.should parse(expr(char('[')))
    %r{\]}.should parse(expr(char(']')))
    %r{\$}.should parse(expr(char('$')))
    %r{\(}.should parse(expr(char('(')))
    %r{\)}.should parse(expr(char(')')))
    %r{\|}.should parse(expr(char('|')))
    %r{\*}.should parse(expr(char('*')))
    %r{\+}.should parse(expr(char('+')))
    %r{\?}.should parse(expr(char('?')))
    %r{\{}.should parse(expr(char('{')))
    %r{\}}.should parse(expr(char('}')))
    %r{\\}.should parse(expr(char('\\')))
  end

  it "should parse characters" do
    %r{foo}.should parse(expr('f', 'o', 'o'))
  end

  it "should parse character with quantifier" do
    %r{a*}.should parse(expr(char('a', :quantifier => '*')))
    %r{a+}.should parse(expr(char('a', :quantifier => '+')))
    %r{a?}.should parse(expr(char('a', :quantifier => '?')))
    %r{a?}.should parse(expr(char('a', :quantifier => '?')))
    %r{a{3}}.should parse(expr(char('a', :quantifier => '{3}')))
    %r{a{3,4}}.should parse(expr(char('a', :quantifier => '{3,4}')))
  end

  it "should parse anchors" do
    %r{^foo}.should parse(expr(
      anchor('^'), 'f', 'o', 'o'
    ))

    %r{\Afoo}.should parse(expr(
      anchor('\A'), 'f', 'o', 'o'
    ))

    %r{foo$}.should parse(expr(
      'f', 'o', 'o',
      anchor('$')
    ))

    %r{foo\Z}.should parse(expr(
      'f', 'o', 'o',
      anchor('\Z')
    ))
  end

  it "should parse wild card range" do
    %r{f..k}.should parse(expr(
      'f',
      range('.'),
      range('.'),
      'k'
    ))

    result = Reginald.parse(%r{f..k})
    result[0].should include('f')
    result[0].should_not include('F')
    result[1].should include('u')
    result[2].should include('c')
    result[3].should include('k')
  end

  it "should parse digit range" do
    %r{\ds}.should parse([range('\d'), char('s')])
  end

  it "should parse bracket expression" do
    %r{[a-z]}.should parse(expr(range('a-z')))
    %r{[0-9]}.should parse(expr(range('0-9')))
    %r{[abc]}.should parse(expr(range('abc')))
  end

  it "should parse bracket expression with special characters" do
    %r{/foo/([^/.?]+)}.should parse([
      '/', 'f', 'o', 'o', '/',
      group([range('/.?', :negate => true, :quantifier => '+')], :index => 0)
    ])
  end

  it "should parse negated bracket expression" do
    %r{[^abc]}.should parse(expr(range('abc', :negate => true)))
    %r{[^/\.\?]}.should parse(expr(range('/.?', :negate => true)))
  end

  it "should parse bracket expression with quantifier" do
    %r{[a-z]+}.should parse([range('a-z', :quantifier => '+')])
  end

  it "should parse alternation" do
    %r{foo|bar}.should parse(
      expr(alt(
        expr('f', 'o', 'o'),
        expr('b', 'a', 'r')
      ))
    )
  end

  it "should parse multiple alternations" do
    %r{abc/(foo|bar|baz)/xyz}.should parse(expr(
      'a', 'b', 'c', '/',
      group(expr(
        alt(
          expr('f', 'o', 'o'),
          expr('b', 'a', 'r'),
          expr('b', 'a', 'z')
        )
      ), :index => 0),
      '/', 'x', 'y', 'z'
    ))
  end

  it "should parse group" do
    %r{/foo(/bar)}.should parse([
      '/', 'f', 'o', 'o',
      group(expr('/', 'b', 'a', 'r'), :index => 0)
    ])
  end

  it "should parse group with quantifier" do
    %r{/foo(/bar)?}.should parse([
      '/', 'f', 'o', 'o',
      group(expr('/', 'b', 'a', 'r'), :quantifier => '?', :index => 0)
    ])
  end

  it "should parse ignorecase option" do
    re = Reginald.parse(/abc/i)
    re.should be_casefold
  end

  it "should parse extend expression" do
    re = /     # foo
           bar # baz
         /x
    re.should parse(['b', 'a', 'r'])
  end

  it "should parse noncapture group" do
    %r{/foo(?:/bar)}.should parse([
      '/', 'f', 'o', 'o',
      group(expr('/', 'b', 'a', 'r'), :capture => false)
    ])
  end

  it "should parse joined expression with no options" do
    Regexp.union(/skiing/, /sledding/).should parse(expr(
      alt(
        expr(group(expr('s', 'k', 'i', 'i', 'n', 'g'), :capture => false)),
        group(expr('s', 'l', 'e', 'd', 'd', 'i', 'n', 'g'), :capture => false)
      )
    ))
  end

  it "should parse joined expression with ignore case" do
    Regexp.union(/dogs/, /cats/i).should parse(expr(
      alt(
        expr(group(expr('d', 'o', 'g', 's'), :capture => false)),
        group(expr('c', 'a', 't', 's', :ignorecase => true), :capture => false)
      )
    ))
  end

  if Reginald.regexp_supports_named_captures?
    it "should parse named group" do
      regexp = eval('%r{/foo(?<bar>baz)}')

      regexp.should parse([
        '/', 'f', 'o', 'o',
        group(expr('b', 'a', 'z'), :name => 'bar', :index => 0)
      ])
    end

    it "should parse nested named group" do
      regexp = eval('%r{a((?<b>c))?}')

      regexp.should parse([
        'a',
        group([
          group(expr('c'), :name => 'b', :index => 1)
        ], :quantifier => '?', :index => 0)
      ])
    end
  end

  private
    def anchor(value)
      Reginald::Anchor.new(value)
    end

    def alt(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      alternation = Reginald::Alternation.new(*args)
      options.each { |k, v| alternation.send("#{k}=", v) }
      alternation
    end

    def char(value, options = {})
      char = Reginald::Character.new(value)
      options.each { |k, v| char.send("#{k}=", v) }
      char
    end

    def range(value, options = {})
      range = Reginald::CharacterClass.new(value)
      options.each { |k, v| range.send("#{k}=", v) }
      range
    end

    def expr(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      expression = Reginald::Expression.new(*args)
      options.each { |k, v| expression.send("#{k}=", v) }
      expression
    end

    def group(value, options = {})
      group = Reginald::Group.new(value)
      options.each { |k, v| group.send("#{k}=", v) }
      group
    end
end
