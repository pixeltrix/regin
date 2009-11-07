module Reginald
  class Group < Struct.new(:value)
    attr_accessor :quantifier, :capture, :name

    def initialize(*args)
      @capture = true
      super
    end

    def to_regexp
      value.map { |e| e.regexp_source }.join
    end

    def regexp_source
      "(#{capture ? '' : '?:'}#{value.map { |e| e.regexp_source }.join})#{quantifier}"
    end

    def capture?
      capture
    end

    def ==(other)
      self.value == other.value &&
        self.quantifier == other.quantifier &&
        self.capture == other.capture &&
        self.name == other.name
    end

    def freeze
      value.each { |e| e.freeze }
    end
  end
end
