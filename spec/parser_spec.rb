require 'test_helper'

describe Regin::Parser do
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
    %r{a{1,23}}.should parse(expr(char('a', :quantifier => '{1,23}')))
    %r{a{1,123}}.should parse(expr(char('a', :quantifier => '{1,123}')))
    %r{a{23,24}}.should parse(expr(char('a', :quantifier => '{23,24}')))
  end

  it "should parse non-greedy quantifiers" do
    %r{a+?}.should parse(expr(char('a', :quantifier => '+?')))
    %r{a*?}.should parse(expr(char('a', :quantifier => '*?')))
  end

  it "should parse anchors" do
    %r{^foo}.should parse(expr(
      anchor('^'), 'f', 'o', 'o'
    ))

    Regin.parse(%r{^foo}).should be_anchored_to_start_of_line

    %r{\Afoo}.should parse(expr(
      anchor('\A'), 'f', 'o', 'o'
    ))

    Regin.parse(%r{\Afoo}).should be_anchored_to_start
    Regin.parse(%r{\Afoo}).should be_anchored_to_start_of_line

    %r{foo$}.should parse(expr(
      'f', 'o', 'o',
      anchor('$')
    ))

    Regin.parse(%r{foo$}).should be_anchored_to_end_of_line

    %r{foo\Z}.should parse(expr(
      'f', 'o', 'o',
      anchor('\Z')
    ))

    Regin.parse(%r{foo\Z}).should be_anchored_to_end
    Regin.parse(%r{foo\Z}).should be_anchored_to_end_of_line

    Regin.parse(%r{^foo$}).should be_anchored_to_line
    Regin.parse(%r{\Afoo\Z}).should be_anchored_to_line
    Regin.parse(%r{\Afoo$}).should be_anchored_to_line
    Regin.parse(%r{^foo\Z}).should be_anchored_to_line
    Regin.parse(%r{\Afoo\Z}).should be_anchored
    Regin.parse(%r{^foo$}).should_not be_anchored
  end

  it "should parse wild card range" do
    %r{f..k}.should parse(expr(
      'f',
      range('.'),
      range('.'),
      'k'
    ))

    result = Regin.parse(%r{f..k})
    result[0].should include('f')
    result[0].should_not include('F')
    result[1].should include('u')
    result[2].should include('c')
    result[3].should include('k')
  end

  it "should parse character ranges" do
    %r{\d}.should parse([range('\d')])
    %r{\D}.should parse([range('\D')])
    %r{\s}.should parse([range('\s')])
    %r{\S}.should parse([range('\S')])
    %r{\w}.should parse([range('\w')])
    %r{\W}.should parse([range('\W')])

    %r{[[:alnum:]]}.should parse([range('[:alnum:]')])
    %r{[[:alpha:]]}.should parse([range('[:alpha:]')])
    %r{[[:blank:]]}.should parse([range('[:blank:]')])
    %r{[[:cntrl:]]}.should parse([range('[:cntrl:]')])
    %r{[[:digit:]]}.should parse([range('[:digit:]')])
    %r{[[:graph:]]}.should parse([range('[:graph:]')])
    %r{[[:lower:]]}.should parse([range('[:lower:]')])
    %r{[[:print:]]}.should parse([range('[:print:]')])
    %r{[[:punct:]]}.should parse([range('[:punct:]')])
    %r{[[:space:]]}.should parse([range('[:space:]')])
    %r{[[:upper:]]}.should parse([range('[:upper:]')])
    %r{[[:xdigit:]]}.should parse([range('[:xdigit:]')])

    %r{[[:alnum:]]{40}}.should parse([range('[:alnum:]', :quantifier => '{40}')])
    %r{[[:upper:]ab]}.should parse([range('[:upper:]ab')])
  end

  it "should parse alnum as a character range" do
    %r{[alnum]}.should parse(expr(range('alnum')))
  end

  it "should parse bracket expression" do
    %r{[a-z]}.should parse(expr(range('a-z')))
    %r{[0-9]}.should parse(expr(range('0-9')))
    %r{[abc]}.should parse(expr(range('abc')))
  end

  it "should parse bracket expression with special characters" do
    %r{/foo/([^/.?]+)}.should parse(expr(
      '/', 'f', 'o', 'o', '/',
      group(expr(range('/.?', :negate => true, :quantifier => '+')), :index => 0)
    ))
  end

  it "should parse negated bracket expression" do
    %r{[^abc]}.should parse(expr(range('abc', :negate => true)))
    %r{[^/\.\?]}.should parse(expr(range('/.?', :negate => true)))
  end

  it "should parse bracket expression with negated not first" do
    %r{[ab^c]}.should parse(expr(range('ab^c')))
  end

  it "should parse bracket expression with quantifier" do
    %r{[a-z]+}.should parse([range('a-z', :quantifier => '+')])
  end

  it "should parse bracket expression with escaped characters" do
    %r{[A-Za-z0-9\-\_\.]}.should parse(expr(range('A-Za-z0-9\-_.')))
  end

  it "should parse bracket expression with character ranges" do
    %r{[\d]+}.should parse(expr(range("\\d", :quantifier => '+')))
    %r{[\D]+}.should parse(expr(range("\\D", :quantifier => '+')))
    %r{[\s]+}.should parse(expr(range("\\s", :quantifier => '+')))
    %r{[\S]+}.should parse(expr(range("\\S", :quantifier => '+')))
    %r{[\w]+}.should parse(expr(range("\\w", :quantifier => '+')))
    %r{[\W]+}.should parse(expr(range("\\W", :quantifier => '+')))
  end

  it "should parse postive look-ahead" do
    %r{^(?=a)}.should parse(expr(
      anchor('^'),
      group(expr('a'), :index => 0, :lookahead => :postive)
    ))
  end

  it "should parse negative look-ahead" do
    %r{^(?!a)}.should parse(expr(
      anchor('^'),
      group(expr('a'), :index => 0, :lookahead => :negative)
    ))
  end

  it "should parse bang characters" do
    %r{!}.should parse(expr(char('!')))
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

    %r{a|b}.should parse(expr(
      alt(expr('a'), expr('b'))
    ))

    %r{a|b|c}.should parse(expr(
      alt(expr('a'), expr('b'), expr('c'))
    ))

    %r{a|b|c|d}.should parse(expr(
      alt(expr('a'), expr('b'), expr('c'), expr('d'))
    ))

    %r{a|b|c|d|e}.should parse(expr(
      alt(expr('a'), expr('b'), expr('c'), expr('d'), expr('e'))
    ))

    %r{a|b|c|d|e|f}.should parse(expr(
      alt(expr('a'), expr('b'), expr('c'), expr('d'), expr('e'), expr('f'))
    ))

    %r{a|b|c|d|e|f|g}.should parse(expr(
      alt(expr('a'), expr('b'), expr('c'), expr('d'), expr('e'), expr('f'), expr('g'))
    ))
  end

  it "should parse group" do
    %r{/foo(/bar)}.should parse(expr(
      '/', 'f', 'o', 'o',
      group(expr('/', 'b', 'a', 'r'), :index => 0)
    ))
  end

  it "should parse group with quantifier" do
    %r{/foo(/bar)?}.should parse(expr(
      '/', 'f', 'o', 'o',
      group(expr('/', 'b', 'a', 'r'), :quantifier => '?', :index => 0)
    ))
  end

  it "should parse ignorecase option" do
    %r{abc}i.should parse(expr('a', 'b', 'c', :ignorecase => true))

    re = Regin.parse(/abc/i)
    re.should be_casefold
    re.to_s.should eql('(?i-mx:abc)')
    re.to_regexp.should eql(%r{abc}i)
  end

  it "should parse explict nested ignorecase" do
    re = Regin.parse(%r{(?-mix:foo)}i)
    re.should be_casefold
    re.to_s.should eql('(?i-mx:(?-mix:foo))')
    re.to_regexp.should eql(%r{(?-mix:foo)}i)
  end

  it "should parse implicit nested ignorecase" do
    re = Regin.parse(%r{(?:foo)}i)
    re.should be_casefold
    re.to_s.should eql('(?i-mx:(?i-mx:foo))')
    re.to_regexp.should eql(%r{(?i-mx:foo)}i)
  end

  it "should parse spaces and pound sign in normal expression" do
    /foo # bar/.should parse(expr('f', 'o', 'o', ' ', '#', ' ', 'b', 'a', 'r'))
  end

  it "should parse extended expression" do
    re = /     # foo
           bar # baz
         /x
    re.should parse(expr('b', 'a', 'r', :extended => true))
  end

  it "should parse inline extended expression" do
    re = %r{/foo/(?x-mi: # comment
              (bar|baz))/ z}
    re.should parse(expr(
      '/', 'f', 'o', 'o', '/',
      group(expr(
        group(expr(
          alt(
            expr('b', 'a', 'r'),
            expr('b', 'a', 'z')
          )
        ), :index => 0),
      :extended => true), :capture => false),
      '/', ' ', 'z')
    )
  end

  it "should parse capture and noncapture groups and set their indexes" do
    re = Regin.parse(/(foo(?:non))(bar(sub))(baz)/)
    re[0].index.should eql(0)
    re[0].expression[3].index.should be_nil
    re[1].index.should eql(1)
    re[1].expression[3].index.should eql(2)
    re[2].index.should eql(3)
  end

  it "should parse noncapture group" do
    %r{/foo(?:/bar)}.should parse(expr(
      '/', 'f', 'o', 'o',
      group(expr('/', 'b', 'a', 'r'), :capture => false)
    ))
  end

  it "should parse joined expression with no options" do
    Regexp.union(/skiing/, /sledding/).should parse(expr(
      alt(
        expr(group(expr('s', 'k', 'i', 'i', 'n', 'g'), :capture => false)),
        expr(group(expr('s', 'l', 'e', 'd', 'd', 'i', 'n', 'g'), :capture => false))
      )
    ))
  end

  it "should parse joined expression with ignore case" do
    Regexp.union(/dogs/, /cats/i).should parse(expr(
      alt(
        expr(group(expr('d', 'o', 'g', 's'), :capture => false)),
        expr(group(expr('c', 'a', 't', 's', :ignorecase => true), :capture => false))
      )
    ))
  end

  if Regin.regexp_supports_named_captures?
    it "should parse named group" do
      regexp = eval('%r{/foo(?<bar>baz)}')

      regexp.should parse(expr(
        '/', 'f', 'o', 'o',
        group(expr('b', 'a', 'z'), :name => 'bar', :index => 0)
      ))
    end

    it "should parse nested named group" do
      regexp = eval('%r{a((?<b>c))?}')

      regexp.should parse(expr(
        'a',
        group(expr(
          group(expr('c'), :name => 'b', :index => 1)
        ), :quantifier => '?', :index => 0)
      ))
    end
  end

  private
    def anchor(*args)
      Regin::Anchor.new(*args)
    end

    def alt(*args)
      Regin::Alternation.new(*args)
    end

    def char(*args)
      Regin::Character.new(*args)
    end

    def range(*args)
      Regin::CharacterClass.new(*args)
    end

    def expr(*args)
      Regin::Expression.new(*args)
    end

    def group(*args)
      Regin::Group.new(*args)
    end
end
