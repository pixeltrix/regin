module Reginald
  class Character < Struct.new(:value)
    attr_accessor :quantifier

    # DEPRECATE
    def regexp_source
      to_s
    end

    def to_s
      "#{value}#{quantifier}"
    end

    def ==(other)
      self.value == other.value &&
        self.quantifier == other.quantifier
    end

    def freeze
      value.freeze
      super
    end
  end
end
