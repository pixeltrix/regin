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

  \(          {
    @state = :OPTIONS if @ss.peek(1) == '?';
    [:LPAREN, text]
  }

  \)          { [:RPAREN,  text] }
  \[          { [:LBRACK,  text] }
  \]          { [:RBRACK,  text] }
  \{          { [:LCURLY,  text] }
  \}          { [:RCURLY,  text] }

  \|          { [:BAR, text]   }
  \.          { [:DOT, text]   }
  \?          { [:QMARK, text] }
  \+          { [:PLUS,  text] }
  \*          { [:STAR,  text] }
  \:          { [:COLON, text] }

  \\(.)       { [:CHAR, @ss[1]] }
  .           { [:CHAR, text] }

  :OPTIONS  \?  {
    @state = nil unless @ss.peek(1) =~ /-|m|i|x|:/
    [:OPTIONS_QMARK, text]
  }
  :OPTIONS  \-  {
    @state = nil unless @ss.peek(1) =~ /-|m|i|x|:/
    [:OPTIONS_MINUS, text]
  }
  :OPTIONS  m {
    @state = nil unless @ss.peek(1) =~ /-|m|i|x|:/
    [:OPTIONS_MULTILINE, text]
  }
  :OPTIONS  i {
    @state = nil unless @ss.peek(1) =~ /-|m|i|x|:/
    [:OPTIONS_IGNORECASE, text]
  }
  :OPTIONS  x {
    @state = nil unless @ss.peek(1) =~ /-|m|i|x|:/
    [:OPTIONS_EXTENDED, text]
  }
  :OPTIONS  \:  {
    @state = nil;
    [:OPTIONS_COLON, text]
  }
end
