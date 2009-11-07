module Reginald
  class Node < Struct.new(:left, :right)
    def flatten
      if left.is_a?(Node)
        left.flatten + [right]
      else
        [left, right]
      end
    end
  end
end
