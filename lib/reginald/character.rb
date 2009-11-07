module Reginald
  class Character < Struct.new(:value)
    attr_accessor :quantifier

    def regexp_source
      "#{value}#{quantifier}"
    end

    def ==(other)
      self.value == other.value &&
        self.quantifier == other.quantifier
    end

    def freeze
      value.freeze
    end
  end
end
