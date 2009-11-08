module Reginald
  class Character < String
    attr_accessor :quantifier

    def initialize(char)
      raise ArgumentError if char.length != 1
      super
    end

    # DEPRECATE
    def regexp_source
      to_s
    end

    def to_s
      "#{super}#{quantifier}"
    end

    def to_regexp
      Regexp.compile("\\A#{to_s}\\Z")
    end

    def match(str)
      to_regexp.match(str)
    end

    def include?(char)
      to_str == char
    end

    def ==(other)
      super &&
        self.quantifier == other.quantifier
    end

    def freeze
      quantifier.freeze
      super
    end
  end
end
