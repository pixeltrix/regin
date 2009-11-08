module Reginald
  class Expression < Array
    attr_accessor :ignorecase

    def initialize(ary)
      if ary.is_a?(Node)
        super(ary.flatten)
      elsif ary.is_a?(Array)
        super(ary)
      else
        super([ary])
      end
    end

    def to_s
      map { |e| e.to_s }.join
    end

    def to_regexp
      Regexp.compile("\\A#{to_s}\\Z")
    end

    def match(char)
      to_regexp.match(char)
    end

    def include?(char)
      any? { |e| e.include?(char) }
    end

    def casefold?
      ignorecase
    end

    def freeze
      each { |e| e.freeze }
      super
    end
  end
end
