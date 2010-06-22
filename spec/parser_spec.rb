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

    Reginald.parse(%r{^foo}).should be_anchored_to_start_of_line

    %r{\Afoo}.should parse(expr(
      anchor('\A'), 'f', 'o', 'o'
    ))

    Reginald.parse(%r{\Afoo}).should be_anchored_to_start
    Reginald.parse(%r{\Afoo}).should be_anchored_to_start_of_line

    %r{foo$}.should parse(expr(
      'f', 'o', 'o',
      anchor('$')
    ))

    Reginald.parse(%r{foo$}).should be_anchored_to_end_of_line

    %r{foo\Z}.should parse(expr(
      'f', 'o', 'o',
      anchor('\Z')
    ))

    Reginald.parse(%r{foo\Z}).should be_anchored_to_end
    Reginald.parse(%r{foo\Z}).should be_anchored_to_end_of_line

    Reginald.parse(%r{^foo$}).should be_anchored_to_line
    Reginald.parse(%r{\Afoo\Z}).should be_anchored_to_line
    Reginald.parse(%r{\Afoo$}).should be_anchored_to_line
    Reginald.parse(%r{^foo\Z}).should be_anchored_to_line
    Reginald.parse(%r{\Afoo\Z}).should be_anchored
    Reginald.parse(%r{^foo$}).should_not be_anchored
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

  it "should parse character ranges" do
    %r{\d}.should parse([range('\d')])
    %r{\D}.should parse([range('\D')])
    %r{\s}.should parse([range('\s')])
    %r{\S}.should parse([range('\S')])
    %r{\w}.should parse([range('\w')])
    %r{\W}.should parse([range('\W')])

    %r{[:alnum:]}.should parse([Reginald::CharacterClass.new(':alnum:')])
    %r{[:alpha:]}.should parse([Reginald::CharacterClass.new(':alpha:')])
    %r{[:ascii:]}.should parse([Reginald::CharacterClass.new(':ascii:')])
    %r{[:blank:]}.should parse([Reginald::CharacterClass.new(':blank:')])
    %r{[:cntrl:]}.should parse([Reginald::CharacterClass.new(':cntrl:')])
    %r{[:digit:]}.should parse([Reginald::CharacterClass.new(':digit:')])
    %r{[:graph:]}.should parse([Reginald::CharacterClass.new(':graph:')])
    %r{[:lower:]}.should parse([Reginald::CharacterClass.new(':lower:')])
    %r{[:print:]}.should parse([Reginald::CharacterClass.new(':print:')])
    %r{[:punct:]}.should parse([Reginald::CharacterClass.new(':punct:')])
    %r{[:space:]}.should parse([Reginald::CharacterClass.new(':space:')])
    %r{[:upper:]}.should parse([Reginald::CharacterClass.new(':upper:')])
    %r{[:word:]}.should parse([Reginald::CharacterClass.new(':word:')])
    %r{[:xdigit:]}.should parse([Reginald::CharacterClass.new(':xdigit:')])
  end

  it "should parse unknown character range" do
    %r{[:foo:]}.should parse(expr(range(':foo:')))
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

    re = Reginald.parse(/abc/i)
    re.should be_casefold
    re.to_s.should eql('(?i-mx:abc)')
    re.to_regexp.should eql(%r{\Aabc\Z}i)
  end

  it "should parse explict nested ignorecase" do
    re = Reginald.parse(%r{(?-mix:foo)}i)
    re.should be_casefold
    re.to_s.should eql('(?i-mx:(?-mix:foo))')
    re.to_regexp.should eql(%r{\A(?-mix:foo)\Z}i)
  end

  it "should parse implicit nested ignorecase" do
    re = Reginald.parse(%r{(?:foo)}i)
    re.should be_casefold
    re.to_s.should eql('(?i-mx:(?i-mx:foo))')
    re.to_regexp.should eql(%r{\A(?i-mx:foo)\Z}i)
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
    re = Reginald.parse(/(foo(?:non))(bar(sub))(baz)/)
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
      Reginald::Anchor.new(*args)
    end

    def alt(*args)
      Reginald::Alternation.new(*args)
    end

    def char(*args)
      Reginald::Character.new(*args)
    end

    def range(*args)
      Reginald::CharacterClass.new(*args)
    end

    def expr(*args)
      Reginald::Expression.new(*args)
    end

    def group(*args)
      Reginald::Group.new(*args)
    end
end
