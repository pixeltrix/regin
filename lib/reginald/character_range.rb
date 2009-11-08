module Reginald
  class CharacterRange < Struct.new(:value)
    attr_accessor :negate, :quantifier

    def negated?
      negate ? true : false
    end

    # DEPRECATE
    def regexp_source
      if value == '.' || value == '\d'
        "#{value}#{quantifier}"
      else
        "[#{negate && '^'}#{value}]#{quantifier}"
      end
    end

    def include?(char)
      Regexp.compile("^#{regexp_source}$") =~ char.to_s
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
