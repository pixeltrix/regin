module Reginald
  class Anchor < Struct.new(:value)
    def literal?
      true
    end

    def freeze
      value.freeze
    end
  end
end
