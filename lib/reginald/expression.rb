module Reginald
  class Expression < Array
    attr_accessor :multiline, :ignorecase, :extended

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
      @multiline = @ignorecase = @extended = false

      if args.length == 1 && args.first.instance_of?(Array)
        super(args.first)
      else
        args = args.map { |e| e.instance_of?(String) ? Character.new(e) : e }
        super(args)
      end
    end

    def literal?
      ignorecase == false && all? { |e| e.literal? }
    end

    def options
      flag = 0
      flag |= Regexp::MULTILINE if multiline
      flag |= Regexp::IGNORECASE if ignorecase
      flag |= Regexp::EXTENDED if extended
      flag
    end

    def to_s_without_options
      map { |e| e.to_s }.join
    end

    def to_s
      if options == 0
        to_s_without_options
      else
        with, without = [], []
        multiline ? (with << 'm') : (without << 'm')
        ignorecase ? (with << 'i') : (without << 'i')
        extended ? (with << 'x') : (without << 'x')

        with = with.join
        without = without.any? ? "-#{without.join}" : ''

        "(?#{with}#{without}:#{to_s_without_options})"
      end
    end

    def to_regexp
      Regexp.compile("\\A#{to_s_without_options}\\Z", options)
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
        self.multiline == other.multiline &&
        self.ignorecase == other.ignorecase &&
        self.extended == other.extended
    end

    def freeze
      each { |e| e.freeze }
      super
    end
  end
end
