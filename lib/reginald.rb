module Reginald
  autoload :Parser, 'reginald/parser'

  begin
    eval('/(?<foo>.*)/').named_captures

    def self.regexp_supports_named_captures?
      true
    end
  rescue SyntaxError, NoMethodError
    def self.regexp_supports_named_captures?
      false
    end
  end

  def self.parse(regexp)
    parser = Parser.new
    expression = parser.scan_str(regexp.source)
    expression.ignorecase = regexp.casefold?
    expression
  end
end
