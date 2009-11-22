class Reginald::Parser
rule
  \\d         { [:CCLASS, CharacterClass.new('\d')] }
  \\D         { [:CCLASS, CharacterClass.new('\D')] }
  \\s         { [:CCLASS, CharacterClass.new('\s')] }
  \\S         { [:CCLASS, CharacterClass.new('\S')] }
  \\w         { [:CCLASS, CharacterClass.new('\w')] }
  \\W         { [:CCLASS, CharacterClass.new('\W')] }

  \^          { [:L_ANCHOR, text] }
  \\A         { [:L_ANCHOR, text] }
  \$          { [:R_ANCHOR, text] }
  \\Z         { [:R_ANCHOR, text] }

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
  \?          { [:QMARK, text] }
  \+          { [:PLUS,  text] }
  \*          { [:STAR,  text] }

  \\(.)       { [:CHAR, @ss[1]] }
  .           { [:CHAR, text] }

  :CCLASS \]        { @state = nil; [:RBRACK, text] }
  :CCLASS \^        { [:NEGATE, text] }
  :CCLASS :alnum:   { [:LC_CTYPE, CharacterClass::ALNUM] }
  :CCLASS :alpha:   { [:LC_CTYPE, CharacterClass::ALPHA] }
  :CCLASS :ascii:   { [:LC_CTYPE, CharacterClass::ASCII] }
  :CCLASS :blank:   { [:LC_CTYPE, CharacterClass::BLANK] }
  :CCLASS :cntrl:   { [:LC_CTYPE, CharacterClass::CNTRL] }
  :CCLASS :digit:   { [:LC_CTYPE, CharacterClass::DIGIT] }
  :CCLASS :graph:   { [:LC_CTYPE, CharacterClass::GRAPH] }
  :CCLASS :lower:   { [:LC_CTYPE, CharacterClass::LOWER] }
  :CCLASS :print:   { [:LC_CTYPE, CharacterClass::PRINT] }
  :CCLASS :punct:   { [:LC_CTYPE, CharacterClass::PUNCT] }
  :CCLASS :space:   { [:LC_CTYPE, CharacterClass::SPACE] }
  :CCLASS :upper:   { [:LC_CTYPE, CharacterClass::UPPER] }
  :CCLASS :word;    { [:LC_CTYPE, CharacterClass::WORD] }
  :CCLASS :xdigit:  { [:LC_CTYPE, CharacterClass::XDIGIT] }
  :CCLASS \\(.)     { [:CHAR, @ss[1]] }
  :CCLASS .         { [:CHAR,     text] }


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
end
