module Reginald
  class Collection < Array
    def initialize(*args)
      args, options = extract_options(args)
      super(*args)
      self.ignorecase = options[:ignorecase]
    end

    def ignorecase=(ignorecase)
      each { |e| e.ignorecase = ignorecase }
      ignorecase
    end

    def dup(options = {})
      collection = super()
      collection.ignorecase = options[:ignorecase] if options[:ignorecase]
      collection
    end

    def to_regexp
      Regexp.compile("\\A#{to_s(true)}\\Z", flags)
    end

    def match(char)
      to_regexp.match(char)
    end

    def include?(char)
      any? { |e| e.include?(char) }
    end

    def ==(other) #:nodoc:
      case other
      when String
        other == to_s
      when Array
        super
      else
        eql?(other)
      end
    end

    def eql?(other) #:nodoc:
      other.instance_of?(self.class) && super
    end

    def freeze #:nodoc:
      each { |e| e.freeze }
      super
    end

    protected
      def extract_options(args)
        if args.last.is_a?(Hash)
          return args[0..-2], args.last
        else
          return args, {}
        end
      end
  end
end
