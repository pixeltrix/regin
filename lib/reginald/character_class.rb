module Reginald
  class CharacterClass < Character
    ALNUM = new(':alnum:').freeze
    ALPHA = new(':alpha:').freeze
    ASCII = new(':ascii:').freeze
    BLANK = new(':blank:').freeze
    CNTRL = new(':cntrl:').freeze
    DIGIT = new(':digit:').freeze
    GRAPH = new(':graph:').freeze
    LOWER = new(':lower:').freeze
    PRINT = new(':print:').freeze
    PUNCT = new(':punct:').freeze
    SPACE = new(':space:').freeze
    UPPER = new(':upper:').freeze
    WORD = new(':word:').freeze
    XDIGIT = new(':xdigit:').freeze

    attr_accessor :negate

    def negated?
      negate ? true : false
    end

    def literal?
      false
    end

    def to_s
      if value == '.' || value =~ /^\\[dDsSwW]$/
        super
      else
        "[#{negate && '^'}#{value}]#{quantifier}"
      end
    end

    def include?(char)
      re = quantifier ? to_s.sub(/#{Regexp.escape(quantifier)}$/, '') : to_s
      Regexp.compile("\\A#{re}\\Z").match(char)
    end

    def eql?(other)
      other.is_a?(self.class) &&
        negate == other.negate &&
        super
    end

    def freeze
      negate.freeze
      super
    end
  end
end
