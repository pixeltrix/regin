module Reginald
  class Character < String
    attr_accessor :quantifier

    def initialize(char)
      raise ArgumentError if char.length != 1
      super
    end

    def literal?
      quantifier.nil?
    end

    def to_s
      "#{super}#{quantifier}"
    end

    def to_regexp
      Regexp.compile("\\A#{to_s}\\Z")
    end

    def match(char)
      to_regexp.match(char)
    end

    def include?(char)
      to_str == char
    end

    def ==(other)
      case other
      when String
        other == to_s
      else
        eql?(other)
      end
    end

    def eql?(other)
      other.is_a?(self.class) && super &&
        self.quantifier == other.quantifier
    end

    def freeze
      quantifier.freeze
      super
    end
  end
end
