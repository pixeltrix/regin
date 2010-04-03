module Reginald
  class Atom
    attr_reader :value
    attr_accessor :ignorecase

    def initialize(value, options = {})
      @value = value
      @ignorecase = options[:ignorecase]
    end

    # Returns true if expression could be treated as a literal string.
    def literal?
      false
    end

    def casefold?
      ignorecase ? true : false
    end

    def dup(options = {})
      atom = super()
      atom.ignorecase = options[:ignorecase] if options[:ignorecase]
      atom
    end

    def to_s(parent = false)
      "#{value}"
    end

    def inspect #:nodoc:
      "#<#{self.class.to_s.sub('Reginald::', '')} #{to_s.inspect}>"
    end

    def ==(other) #:nodoc:
      case other
      when String
        other == to_s
      else
        eql?(other)
      end
    end

    def eql?(other) #:nodoc:
      other.instance_of?(self.class) &&
        self.value.eql?(other.value) &&
        (!!self.ignorecase).eql?(!!other.ignorecase)
    end

    def freeze #:nodoc:
      value.freeze
      super
    end
  end
end
