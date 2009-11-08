module Reginald
  autoload :Anchor, 'reginald/anchor'
  autoload :Character, 'reginald/character'
  autoload :CharacterRange, 'reginald/character_range'
  autoload :Expression, 'reginald/expression'
  autoload :Group, 'reginald/group'
  autoload :Node, 'reginald/node'
  autoload :Parser, 'reginald/parser'

  begin
    eval('/(?<foo>.*)/').named_captures

    def self.regexp_supports_named_captures?
      true
    end
  rescue SyntaxError, NoMethodError
    def self.regexp_supports_named_captures?
      false
    end
  end

  def self.parse(regexp)
    # TODO: The parser should be aware of extended expressions
    # instead of having to sanitize them before.
    if regexp.options & Regexp::EXTENDED != 0
      source = regexp.source
      source.gsub!(/#.+$/, '')
      source.gsub!(/\s+/, '')
      source.gsub!(/\\\//, '/')
      regexp = Regexp.compile(source)
    end

    parser = Parser.new
    expression = parser.scan_str(regexp.source)
    expression.ignorecase = regexp.casefold?
    expression
  end
end
