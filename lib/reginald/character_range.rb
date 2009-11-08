module Reginald
  class CharacterRange < Struct.new(:value)
    attr_accessor :negate, :quantifier

    def negated?
      negate ? true : false
    end

    def to_s
      if value == '.' || value == '\d'
        "#{value}#{quantifier}"
      else
        "[#{negate && '^'}#{value}]#{quantifier}"
      end
    end

    def to_regexp
      Regexp.compile("\\A#{to_s}\\Z")
    end

    def match(char)
      to_regexp.match(char)
    end

    def include?(char)
      re = quantifier ? to_s.sub(/#{Regexp.escape(quantifier)}$/, '') : to_s
      Regexp.compile("\\A#{re}\\Z").match(char)
    end

    def ==(other)
      self.value == other.value &&
        self.negate == other.negate &&
        self.quantifier == other.quantifier
    end

    def freeze
      value.freeze
      super
    end
  end
end
