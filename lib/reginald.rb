module Reginald
  autoload :Alternation, 'reginald/alternation'
  autoload :Anchor, 'reginald/anchor'
  autoload :Atom, 'reginald/atom'
  autoload :Character, 'reginald/character'
  autoload :CharacterClass, 'reginald/character_class'
  autoload :Expression, 'reginald/expression'
  autoload :Group, 'reginald/group'
  autoload :Parser, 'reginald/parser'

  class << self
    begin
      eval('foo = /(?<foo>.*)/').named_captures

      def regexp_supports_named_captures?
        true
      end
    rescue SyntaxError, NoMethodError
      def regexp_supports_named_captures?
        false
      end
    end

    def parse(regexp)
      regexp = strip_extended_whitespace_and_comments(regexp)

      parser = Parser.new
      parser.capture_index = 0
      parser.capture_index_stack = []
      expression = parser.scan_str(regexp.source)

      expression.ignorecase = regexp.casefold?

      expression
    end

    def compile(source)
      regexp = Regexp.compile(source)
      expression = parse(regexp)
      Regexp.compile(expression.to_s_without_options, expression.options)
    end

    private
      # TODO: The parser should be aware of extended expressions
      # instead of having to sanitize them before.
      def strip_extended_whitespace_and_comments(regexp)
        if regexp.options & Regexp::EXTENDED != 0
          source = regexp.source
          source.gsub!(/#.+$/, '')
          source.gsub!(/\s+/, '')
          source.gsub!(/\\\//, '/')
          regexp = Regexp.compile(source)
        else
          regexp
        end
      end
  end
end
