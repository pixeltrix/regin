module Reginald
  class Character < Struct.new(:value)
    attr_accessor :quantifier

    def literal?
      quantifier.nil?
    end

    def to_s
      "#{value}#{quantifier}"
    end

    def to_regexp
      Regexp.compile("\\A#{to_s}\\Z")
    end

    def inspect
      "#<#{self.class.to_s.sub('Reginald::', '')} #{to_s.inspect}>"
    end

    def match(char)
      to_regexp.match(char)
    end

    def include?(char)
      value == char
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
      other.is_a?(self.class) &&
        value.eql?(other.value) &&
        quantifier.eql?(other.quantifier)
    end

    def freeze
      value.freeze
      quantifier.freeze
      super
    end
  end
end
