class Reginald::Parser
rule
  expression: expression BAR branch { result = Expression.new(Alternation.reduce(val[0], val[2])) }
            | branch { result = Expression.reduce(val[0]) }

  branch: branch atom quantifier { result = Expression.reduce(val[0], val[1].dup(:quantifier => val[2])) }
        | branch atom { result = Expression.reduce(val[0], val[1]) }
        | atom quantifier { result = val[0].dup(:quantifier => val[1]) }
        | atom

  atom: group
      | LBRACK ctype RBRACK { result = val[1] }
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
            | LCURLY CHAR CHAR CHAR RCURLY { result = val.join }
            | LCURLY CHAR RCURLY { result = val.join }


  # Bracketed expressions
  bracket_expression: bracket_expression CHAR   { result = val.join }
                    | bracket_expression NEGATE { result = val.join }
                    | CHAR
                    | NEGATE

  ctype: "alnum"  { result = CharacterClass::ALNUM }
       | "alpha"  { result = CharacterClass::ALPHA }
       | "ascii"  { result = CharacterClass::ASCII }
       | "blank"  { result = CharacterClass::BLANK }
       | "cntrl"  { result = CharacterClass::CNTRL }
       | "digit"  { result = CharacterClass::DIGIT }
       | "graph"  { result = CharacterClass::GRAPH }
       | "lower"  { result = CharacterClass::LOWER }
       | "print"  { result = CharacterClass::PRINT }
       | "punct"  { result = CharacterClass::PUNCT }
       | "space"  { result = CharacterClass::SPACE }
       | "upper"  { result = CharacterClass::UPPER }
       | "word"   { result = CharacterClass::WORD  }
       | "xdigit" { result = CharacterClass::XDIGIT }

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

  if options.any?
    expression.multiline  = options.multiline
    expression.ignorecase = options.ignorecase
    expression.extended   = options.extended
  end

  expression
end

attr_accessor :options_stack

def initialize
  @capture_index = 0
  @capture_index_stack = []
  @options_stack = []
end

---- footer
require 'reginald/tokenizer'
