class Regin::Parser
rule
  \\[dDsSwW]  { [:CCLASS, text] }

  \^|\\A      { [:L_ANCHOR, text] }
  \$|\\Z      { [:R_ANCHOR, text] }

  <(\w+)>     { [:NAME, @ss[1]] }

  \(          {
    @capture_index_stack << @capture_index
    @capture_index += 1

    @state = :OPTIONS if @ss.peek(1) == '?';
    [:LPAREN, text]
  }

  \)          { [:RPAREN,  text] }
  \[          { @state = :CCLASS; [:LBRACK,  text] }
  \{          { [:LCURLY,  text] }
  \}          { [:RCURLY,  text] }

  \|          { [:BAR, text]   }
  \.          { [:DOT, text]   }
  \!          { [:BANG, text]  }
  \=          { [:EQUAL, text] }
  \?          { [:QMARK, text] }
  \+          { [:PLUS,  text] }
  \*          { [:STAR,  text] }

  \#          {
    if @options_stack[-1][:extended]
      @state = :COMMENT;
      next_token
    else
      [:CHAR, text]
    end
  }
  \s|\n       {
    if @options_stack[-1][:extended]
      next_token
    else
      [:CHAR, text]
    end
  }

  \\(.)       { [:CHAR, @ss[1]] }
  .           { [:CHAR, text] }


  :CCLASS \[           { [:LBRACK,  text] }
  :CCLASS \]           { @state = nil; [:RBRACK, text] }
  :CCLASS \^           { [@ss.string[@ss.pos-2, 1] == '[' ? :NEGATE : :CHAR, text] }
  :CCLASS :            {
    if @ss.string[@ss.pos-2, 1] == '['
      @state = :POSIX_CCLASS
      [:COLON, text]
    else
      [:CHAR, text]
    end
  }
  :CCLASS \\-          { [:CHAR, text] }
  :CCLASS \\[dDsSwW]   { [:CHAR, text] }
  :CCLASS \\(.)        { [:CHAR, @ss[1]] }
  :CCLASS .            { [:CHAR, text] }

  :POSIX_CCLASS \w+    { [text, text] }
  :POSIX_CCLASS :      { [:COLON, text] }
  :POSIX_CCLASS \]     { @state = :CCLASS; [:RBRACK, text] }


  :OPTIONS  \?  {
    @state = nil unless @ss.peek(1) =~ /-|m|i|x|:/
    [:QMARK, text]
  }
  :OPTIONS  \-  { [:MINUS, text] }
  :OPTIONS  m   { [:MULTILINE, text] }
  :OPTIONS  i   { [:IGNORECASE, text] }
  :OPTIONS  x   { [:EXTENDED, text] }
  :OPTIONS  \:  {
    @capture_index_stack.pop
    @capture_index -= 1
    @state = nil;
    [:COLON, text]
  }


  :COMMENT  \n  { @state = nil; next_token }
  :COMMENT  .   { next_token }
end
