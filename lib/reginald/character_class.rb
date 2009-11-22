module Reginald
  class CharacterClass < Character
    attr_accessor :negate

    def negated?
      negate ? true : false
    end

    def literal?
      false
    end

    def to_s
      if value == '.' || value == '\d'
        super
      else
        "[#{negate && '^'}#{value}]#{quantifier}"
      end
    end

    def include?(char)
      re = quantifier ? to_s.sub(/#{Regexp.escape(quantifier)}$/, '') : to_s
      Regexp.compile("\\A#{re}\\Z").match(char)
    end

    def eql?(other)
      other.is_a?(self.class) &&
        negate == other.negate &&
        super
    end

    def freeze
      negate.freeze
      super
    end
  end
end
