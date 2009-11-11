class Reginald::Parser
rule
  expression: expression BAR branch { result = Expression.new([Alternation.reduce(val[0], val[2])]) }
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
      | LBRACK bracket_expression RBRACK { result = CharacterClass.new(val[1]) }
      | LBRACK L_ANCHOR bracket_expression RBRACK { result = CharacterClass.new(val[2]); result.negate = true }
      | CHAR_CLASS { result = CharacterClass.new(val[0]) }
      | DOT { result = CharacterClass.new(val[0]) }
      | anchor { result = Anchor.new(val[0]) }
      | CHAR { result = Character.new(val[0]) }

  bracket_expression: bracket_expression CHAR { result = val.join }
                    | bracket_expression DOT { result = val.join }
                    | bracket_expression QMARK { result = val.join }
                    | CHAR
                    | DOT
                    | QMARK

  group: LPAREN expression RPAREN { result = Group.new(val[1]) }
       | LPAREN QMARK COLON expression RPAREN { result = Group.new(val[3]); result.capture = false }
       | LPAREN QMARK NAME expression RPAREN { result = Group.new(val[3]); result.name = val[2] }

  anchor: L_ANCHOR
        | R_ANCHOR

  quantifier: STAR
            | PLUS
            | QMARK
            | LCURLY CHAR CHAR CHAR RCURLY { result = val.join }
            | LCURLY CHAR RCURLY { result = val.join }
end

---- header
require 'reginald/tokenizer'
