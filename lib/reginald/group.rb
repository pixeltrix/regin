module Reginald
  class Group
    attr_reader :expression, :quantifier, :capture, :index, :name

    def initialize(expression, options = {})
      @quantifier = @index = @name = nil
      @capture = true
      @expression = expression

      self.quantifier = options[:quantifier] if options.key?(:quantifier)
      self.capture    = options[:capture] if options.key?(:capture)
      self.index      = options[:index] if options.key?(:index)
      self.name       = options[:name] if options.key?(:name)

      self.multiline  = options[:multiline] if options.key?(:multiline)
      self.ignorecase = options[:ignorecase] if options.key?(:ignorecase)
      self.extended   = options[:extended] if options.key?(:extended)
    end

    def ignorecase=(ignorecase)
      expression.ignorecase = ignorecase
    end

    # Returns true if expression could be treated as a literal string.
    #
    # A Group is literal if its expression is literal and it has no quantifier.
    def literal?
      quantifier.nil? && expression.literal?
    end

    def to_s(parent = false)
      if !expression.options?
        "(#{capture ? '' : '?:'}#{expression.to_s(parent)})#{quantifier}"
      elsif capture == false
        "#{expression.to_s}#{quantifier}"
      else
        "(#{expression.to_s})#{quantifier}"
      end
    end

    def to_regexp
      Regexp.compile("\\A#{to_s}\\Z")
    end

    def dup(options = {})
      group = super()
      group.ignorecase = options[:ignorecase] if options.key?(:ignorecase)
      group.quantifier = options[:quantifier] if options.key?(:quantifier)
      group.capture = options[:capture] if options.key?(:capture)
      group.index = options[:index] if options.key?(:index)
      group.name = options[:name] if options.key?(:name)
      group
    end

    def inspect #:nodoc:
      to_s.inspect
    end

    def match(char)
      to_regexp.match(char)
    end

    def include?(char)
      expression.include?(char)
    end

    def capture?
      capture
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
      other.is_a?(self.class) &&
        self.expression == other.expression &&
        self.quantifier == other.quantifier &&
        self.capture == other.capture &&
        self.index == other.index &&
        self.name == other.name
    end

    def freeze #:nodoc:
      expression.freeze
      super
    end

    protected
      # TODO Remove quantifier writer
      def quantifier=(quantifier)
        @quantifier = quantifier
      end

      # TODO Remove capture writer
      def capture=(capture)
        @capture = capture
      end

      # TODO Remove index writer
      def index=(index)
        @index = index
      end

      # TODO Remove name writer
      def name=(name)
        @name = name
      end

      # TODO Remove multiline writer
      def multiline=(multiline)
        expression.multiline = multiline
      end

      # TODO Remove extended writer
      def extended=(extended)
        expression.extended = extended
      end
  end
end
