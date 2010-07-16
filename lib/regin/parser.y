class Regin::Parser
rule
  expression: alternation { result = Expression.new(val[0]) }
            | subexpression

  alternation: alternation BAR subexpression { result = val[0] + [val[2]] }
             | subexpression BAR subexpression { result = Alternation.new(val[0], val[2])  }

  subexpression: expression_ary { result = Expression.new(val[0]) }

  expression_ary: expression_ary quantified_atom { result = val[0] + [val[1]] }
                | quantified_atom { result = [val[0]] }

  quantified_atom: atom quantifier { result = val[0].dup(:quantifier => val[1]) }
                 | atom

  atom: group
      | LBRACK CTYPE RBRACK { result = CharacterClass.new(val[1]) }
      | LBRACK bracket_expression RBRACK { result = CharacterClass.new(val[1]) }
      | LBRACK NEGATE bracket_expression RBRACK { result = CharacterClass.new(val[2], :negate => true) }
      | CCLASS { result = CharacterClass.new(val[0]) }
      | DOT { result = CharacterClass.new('.') }
      | anchor { result = Anchor.new(val[0]) }
      | CHAR { result = Character.new(val[0]) }

  group: LPAREN expression RPAREN {
          result = Group.new(val[1], :index => @capture_index_stack.pop)
        }
       | LPAREN QMARK options COLON expression RPAREN {
          result = Group.new(val[4], val[2].merge(:capture => false))
          @options_stack.pop
        }
       | LPAREN QMARK COLON expression RPAREN {
          result = Group.new(val[3], :capture => false);
        }
       | LPAREN QMARK NAME expression RPAREN {
          result = Group.new(val[3], :name => val[2], :index => @capture_index_stack.pop);
        }

  anchor: L_ANCHOR
        | R_ANCHOR

  quantifier: STAR
            | PLUS
            | QMARK
            | STAR QMARK { result = val.join }
            | PLUS QMARK { result = val.join }
            | LCURLY quantifier_char RCURLY { result = val.join }

  quantifier_char: quantifier_char CHAR { result = val.join }
                 | CHAR

  # Bracketed expressions
  bracket_expression: bracket_expression CHAR { result = val.join }
                    | CHAR

  # Inline options
  options: MINUS modifier modifier modifier {
            @options_stack << result = { val[1] => false, val[2] => false, val[3] => false }
          }
         | modifier MINUS modifier modifier {
            @options_stack << result = { val[0] => true, val[2] => false, val[3] => false }
          }
         | modifier modifier MINUS modifier {
            @options_stack << result = { val[0] => true, val[1] => true, val[3] => false }
          }
         | modifier modifier modifier       {
            @options_stack << result = { val[0] => true, val[1] => true, val[2] => true }
          }

  modifier: MULTILINE  { result = :multiline }
          | IGNORECASE { result = :ignorecase }
          | EXTENDED   { result = :extended }
end

---- inner
def self.parse_regexp(regexp)
  options = Options.from_int(regexp.options)

  parser = new
  parser.options_stack << options.to_h

  expression = parser.scan_str(regexp.source)
  expression = expression.dup(options.to_h) if options.any?
  expression
end

attr_accessor :options_stack

def initialize
  @capture_index = 0
  @capture_index_stack = []
  @options_stack = []
end

---- footer
require 'regin/tokenizer'
