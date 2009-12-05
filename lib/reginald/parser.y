class Reginald::Parser
rule
  expression: expression BAR branch { result = Expression.new(Alternation.reduce(val[0], val[2])) }
            | branch { result = Expression.reduce(val[0]) }

  branch: branch atom quantifier {
            val[1].quantifier = val[2]
            result = Expression.reduce(val[0], val[1])
          }
        | branch atom { result = Expression.reduce(val[0], val[1]) }
        | atom quantifier {
            val[0].quantifier = val[1]
            result = val[0]
          }
        | atom

  atom: group
      | LBRACK ctype RBRACK { result = val[1] }
      | LBRACK bracket_expression RBRACK { result = CharacterClass.new(val[1]) }
      | LBRACK NEGATE bracket_expression RBRACK { result = CharacterClass.new(val[2]); result.negate = true }
      | CCLASS { result = CharacterClass.new(val[0]) }
      | DOT { result = CharacterClass.new('.') }
      | anchor { result = Anchor.new(val[0]) }
      | CHAR { result = Character.new(val[0]) }

  group: LPAREN expression RPAREN {
          result = Group.new(val[1])
          result.index = @capture_index_stack.pop
        }
       | LPAREN QMARK options COLON expression RPAREN {
          result = Group.new(val[4]);
          result.capture = false;
          options = val[2];
          result.expression.multiline  = options[:multiline];
          result.expression.ignorecase = options[:ignorecase];
          result.expression.extended   = options[:extended];
        }
       | LPAREN QMARK COLON expression RPAREN {
          result = Group.new(val[3]);
          result.capture = false;
        }
       | LPAREN QMARK NAME expression RPAREN {
          result = Group.new(val[3]);
          result.name = val[2];
          result.index = @capture_index_stack.pop
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
  options: MINUS modifier modifier modifier { result = { val[1] => false, val[2] => false, val[3] => false } }
         | modifier MINUS modifier modifier { result = { val[0] => true, val[2] => false, val[3] => false } }
         | modifier modifier MINUS modifier { result = { val[0] => true, val[1] => true, val[3] => false } }
         | modifier modifier modifier       { result = { val[0] => true, val[1] => true, val[2] => true } }

  modifier: MULTILINE  { result = :multiline }
          | IGNORECASE { result = :ignorecase }
          | EXTENDED   { result = :extended }
end

---- inner
def self.scan_str(str)
  new.scan_str(str)
end

def initialize
  @capture_index = 0
  @capture_index_stack = []
end

---- footer
require 'reginald/tokenizer'
