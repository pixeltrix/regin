module Reginald
  class Expression < Array
    attr_accessor :ignorecase

    def self.reduce(expression_or_atom, atom = nil)
      if expression_or_atom.is_a?(Expression)
        expression_or_atom << atom if atom
        new(*expression_or_atom)
      elsif atom.nil?
        new(expression_or_atom)
      else
        new(expression_or_atom, atom)
      end
    end

    def initialize(*args)
      @ignorecase = false

      if args.length == 1 && args.first.is_a?(Array)
        super(args.first)
      else
        super(args)
      end
    end

    def literal?
      ignorecase == false && all? { |e| e.literal? }
    end

    def to_s
      map { |e| e.to_s }.join
    end

    def to_regexp
      Regexp.compile("\\A#{to_s}\\Z")
    end

    def inspect
      "#<Expression #{to_s.inspect}>"
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

    def ==(other)
      case other
      when String
        other == to_s
      when Array
        super
      else
        eql?(other)
      end
    end

    def eql?(other)
      other.is_a?(self.class) && super &&
        self.ignorecase == other.ignorecase
    end

    def freeze
      each { |e| e.freeze }
      super
    end
  end
end
