module Reginald
  class Anchor < Struct.new(:value)
    def freeze
      value.freeze
    end
  end
end
