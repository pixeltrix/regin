module Reginald
  class Expression < Array
    attr_accessor :ignorecase

    def initialize(ary)
      if ary.is_a?(Node)
        super(ary.flatten)
      else
        super([ary])
      end
    end

    def casefold?
      ignorecase
    end

    def freeze
      each { |e| e.freeze }
    end
  end
end
