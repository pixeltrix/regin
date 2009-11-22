module Reginald
  class Atom < Struct.new(:value)
    def literal?
      false
    end

    def to_s
      "#{value}"
    end

    def inspect
      "#<#{self.class.to_s.sub('Reginald::', '')} #{to_s.inspect}>"
    end

    def freeze
      value.freeze
      super
    end
  end
end
