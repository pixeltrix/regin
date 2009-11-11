module Reginald
  class Anchor < Struct.new(:value)
    def to_s
      "#{value}"
    end

    def inspect
      to_s.inspect
    end

    def literal?
      false
    end

    def freeze
      value.freeze
      super
    end
  end
end
