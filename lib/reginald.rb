module Reginald
  autoload :Alternation, 'reginald/alternation'
  autoload :Anchor, 'reginald/anchor'
  autoload :Character, 'reginald/character'
  autoload :CharacterClass, 'reginald/character_class'
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

    capture_index = 0
    tag_captures = Proc.new do |expr|
      expr.each do |atom|
        if atom.is_a?(Group)
          if atom.capture
            atom.index = capture_index
            capture_index += 1
          end
          tag_captures.call(atom)
        elsif atom.is_a?(Expression)
          tag_captures.call(atom)
        end
      end
    end
    tag_captures.call(expression)

    expression
  end
end
