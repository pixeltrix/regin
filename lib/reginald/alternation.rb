module Reginald
  class Alternation < Array
    def self.reduce(alternation_or_expression, expression)
      if alternation_or_expression.first.is_a?(Alternation)
        alternation_or_expression = alternation_or_expression.first
        alternation_or_expression << expression
        new(*alternation_or_expression)
      else
        new(alternation_or_expression, expression)
      end
    end

    def initialize(*args)
      if args.length == 1 && args.first.is_a?(Array)
        super(args.first)
      else
        super(args)
      end
    end

    def literal?
      false
    end

    def to_s
      map { |e| e.to_s }.join('|')
    end

    def to_regexp
      Regexp.compile("\\A#{to_s}\\Z")
    end

    def inspect
      to_s.inspect
    end

    def match(char)
      to_regexp.match(char)
    end

    def include?(char)
      any? { |e| e.include?(char) }
    end

    def freeze
      each { |e| e.freeze }
      super
    end
  end
end
