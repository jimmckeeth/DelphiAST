[![](https://tokei.rs/b1/github/jimmckeeth/DelphiAST?category=lines)](https://github.com/jimmckeeth/DelphiAST) [![](https://tokei.rs/b1/github/jimmckeeth/DelphiAST?category=code)](https://github.com/jimmckeeth/DelphiAST) [![](https://tokei.rs/b1/github/jimmckeeth/DelphiAST?category=files)](https://github.com/jimmckeeth/DelphiAST)

**Update:** This is a fork of [Roman Yankovsky's original](https://github.com/RomanYankovsky/DelphiAST), pulling in changes from [other forks](https://github.com/RomanYankovsky/DelphiAST/network). I wll review the exising [pull requests](https://github.com/RomanYankovsky/DelphiAST/pulls) and am accepting [new ones here](https://github.com/jimmckeeth/DelphiAST/pulls).

# Abstract Syntax Tree (AST) Builder for Object Pascal
[<img src="https://raw.githubusercontent.com/jimmckeeth/DelphiAST/refs/heads/master/Graphics/ObjectPascalAST.png" align="right" width="250">](https://github.com/jimmckeeth/DelphiAST/)

With [DelphiAST](https://github.com/jimmckeeth/DelphiAST/) you can take real Delphi code and get an abstract syntax tree. One unit at time and without a symbol table though. 

Compatible with [Delphi](https://www.embarcadero.com/products/delphi), [FreePascal](https://www.freepascal.org/), & [Lazarus](https://www.lazarus-ide.org/).

## Sample input
```delphi
unit Unit1;

interface

uses
  Unit2;

function Sum(A, B: Integer): Integer;

implementation

function Sum(A, B: Integer): Integer;
begin
  Result := A + B;
end;

end.
```

#### Sample outcome
```xml
<UNIT line="1" col="1" name="Unit1">
  <INTERFACE begin_line="3" begin_col="1" end_line="10" end_col="1">
    <USES begin_line="5" begin_col="1" end_line="8" end_col="1">
      <UNIT line="6" col="3" name="Unit2"/>
    </USES>
    <METHOD begin_line="8" begin_col="1" end_line="10" end_col="1" kind="function" name="Sum">
      <PARAMETERS line="8" col="13">
        <PARAMETER line="8" col="14">
          <NAME line="8" col="14" value="A"/>
          <TYPE line="8" col="20" name="Integer"/>
        </PARAMETER>
        <PARAMETER line="8" col="17">
          <NAME line="8" col="17" value="B"/>
          <TYPE line="8" col="20" name="Integer"/>
        </PARAMETER>
      </PARAMETERS>
      <RETURNTYPE line="8" col="30">
        <TYPE line="8" col="30" name="Integer"/>
      </RETURNTYPE>
    </METHOD>
  </INTERFACE>
  <IMPLEMENTATION begin_line="10" begin_col="1" end_line="17" end_col="1">
    <METHOD begin_line="12" begin_col="1" end_line="17" end_col="1" kind="function" name="Sum">
      <PARAMETERS line="12" col="13">
        <PARAMETER line="12" col="14">
          <NAME line="12" col="14" value="A"/>
          <TYPE line="12" col="20" name="Integer"/>
        </PARAMETER>
        <PARAMETER line="12" col="17">
          <NAME line="12" col="17" value="B"/>
          <TYPE line="12" col="20" name="Integer"/>
        </PARAMETER>
      </PARAMETERS>
      <RETURNTYPE line="12" col="30">
        <TYPE line="12" col="30" name="Integer"/>
      </RETURNTYPE>
      <STATEMENTS begin_line="13" begin_col="1" end_line="15" end_col="4">
        <ASSIGN line="14" col="3">
          <LHS line="14" col="3">
            <IDENTIFIER line="14" col="3" name="Result"/>
          </LHS>
          <RHS line="14" col="13">
            <EXPRESSION line="14" col="13">
              <ADD line="14" col="15">
                <IDENTIFIER line="14" col="13" name="A"/>
                <IDENTIFIER line="14" col="17" name="B"/>
              </ADD>
            </EXPRESSION>
          </RHS>
        </ASSIGN>
      </STATEMENTS>
    </METHOD>
  </IMPLEMENTATION>
</UNIT>
```

#### Copyright
Copyright (c) 2014-2020 Roman Yankovsky (roman@yankovsky.me) et al

DelphiAST is released under the Mozilla Public License, v. 2.0

See LICENSE for details.
