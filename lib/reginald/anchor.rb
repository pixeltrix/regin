module Reginald
  class Anchor < Struct.new(:value)
    def literal?
      false
    end

    def freeze
      value.freeze
      super
    end
  end
end
