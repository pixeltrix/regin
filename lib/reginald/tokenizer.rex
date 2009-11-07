class Reginald::Parser
rule
  \\c         { [:CHAR_CLASS, text] }
  \\s         { [:CHAR_CLASS, text] }
  \\S         { [:CHAR_CLASS, text] }
  \\d         { [:CHAR_CLASS, text] }
  \\w         { [:CHAR_CLASS, text] }
  \\W         { [:CHAR_CLASS, text] }

  \^          { [:L_ANCHOR, text] }
  \\A         { [:L_ANCHOR, text] }
  \$          { [:R_ANCHOR, text] }
  \\Z         { [:R_ANCHOR, text] }

  <(\w+)>     { [:NAME, @ss[1]] }

  \(          { [:LPAREN,  text] }
  \)          { [:RPAREN,  text] }
  \[          { [:LBRACK,  text] }
  \]          { [:RBRACK,  text] }
  \{          { [:LCURLY,  text] }
  \}          { [:RCURLY,  text] }

  \.          { [:DOT, text] }
  \?          { [:QMARK, text] }
  \+          { [:PLUS,  text] }
  \*          { [:STAR,  text] }
  \:          { [:COLON, text] }

  \\(.)       { [:CHAR, @ss[1]] }
  .           { [:CHAR, text] }
end
