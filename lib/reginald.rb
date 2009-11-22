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
      eval('/(?<foo>.*)/').named_captures

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
      expression = parser.scan_str(regexp.source)

      expression.ignorecase = regexp.casefold?

      tag_captures!(expression)

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

      # TODO: The parser should tag capture indexes
      def tag_captures!(expression)
        capture_index = 0
        iterator = Proc.new do |expr|
          expr.each do |atom|
            if atom.is_a?(Group)
              if atom.capture
                atom.index = capture_index
                capture_index += 1
              end
              iterator.call(atom)
            elsif atom.is_a?(Expression)
              iterator.call(atom)
            end
          end
        end
        iterator.call(expression)
      end
  end
end
