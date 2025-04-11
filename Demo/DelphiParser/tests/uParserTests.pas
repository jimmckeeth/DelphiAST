unit uParserTests;

interface

uses
  DUnitX.TestFramework,
  uParserCore;

type
  [TestFixture]
  TParserTests = class
  private
  FParser: TParserCore;
  FTestDataPath: string;
  public
  [Setup]
  procedure Setup;
  [TearDown]
  procedure TearDown;

  [Test]
  procedure TestValidPasFile;
  [Test]
  procedure TestValidDprFile;
  [Test]
  procedure TestFileWithIncludes;
  [Test]
  procedure TestInvalidSyntax;
  [Test]
  procedure TestMissingIncludeFile;
  [Test]
  procedure TestMemoryUsage;
  [Test]
  procedure TestStringInterning;
  [Test]
  procedure TestBlank;
  end;

implementation

uses
  System.SysUtils, System.IOUtils;

{ TParserTests }

procedure TParserTests.Setup;
begin
  FParser := TParserCore.Create;
  FTestDataPath := TPath.Combine(ExtractFilePath(ParamStr(0)), '..\..\data');
end;

procedure TParserTests.TearDown;
begin
  FParser.Free;
end;

procedure TParserTests.TestValidPasFile;
begin
  Assert.IsTrue(FParser.Parse(TPath.Combine(FTestDataPath, 'SimpleUnit.pas')), 
  'Should parse valid pas file');
  Assert.IsNotEmpty(FParser.XMLOutput, 'XML output should not be empty');
end;

procedure TParserTests.TestValidDprFile;
begin
  Assert.IsTrue(FParser.Parse(TPath.Combine(FTestDataPath, 'SimpleProject.dpr')),
  'Should parse valid dpr file');
  Assert.IsNotEmpty(FParser.XMLOutput, 'XML output should not be empty');
end;

procedure TParserTests.TestBlank;
begin
  Assert.IsFalse(FParser.Parse(TPath.Combine(FTestDataPath, 'blank.txt')),
    'Should fail on invalid syntax');
  Assert.IsNotEmpty(FParser.Errors, 'Should have error message');
end;

procedure TParserTests.TestFileWithIncludes;
begin
  Assert.IsTrue(FParser.Parse(TPath.Combine(FTestDataPath, 'UnitWithIncludes.pas')),
    'Should parse file with includes');
  Assert.IsNotEmpty(FParser.XMLOutput, 'XML output should not be empty');
end;

procedure TParserTests.TestInvalidSyntax;
begin
  Assert.IsFalse(FParser.Parse(TPath.Combine(FTestDataPath, 'InvalidSyntax.pas')),
    'Should fail on invalid syntax');
  Assert.IsNotEmpty(FParser.Errors, 'Should have error message');
end;

procedure TParserTests.TestMissingIncludeFile;
begin
  Assert.IsFalse(FParser.Parse(TPath.Combine(FTestDataPath, 'MissingInclude.pas')),
  'Should fail on missing include file');
  Assert.IsNotEmpty(FParser.Errors, 'Should have error message');
end;

procedure TParserTests.TestMemoryUsage;
begin
//  FParser.Parse(TPath.Combine(FTestDataPath, 'LargeUnit.pas'));
//  Assert.IsTrue(FParser.MemoryUsage > 0, 'Should track memory usage');
end;

procedure TParserTests.TestStringInterning;
var
  MemoryWithoutInterning, MemoryWithInterning: Cardinal;
begin
  FParser.UseStringInterning := False;
  FParser.Parse(TPath.Combine(FTestDataPath, 'DuplicateStrings.pas'));
  MemoryWithoutInterning := FParser.MemoryUsage;

  FParser.UseStringInterning := True;
  FParser.Parse(TPath.Combine(FTestDataPath, 'DuplicateStrings.pas'));
  MemoryWithInterning := FParser.MemoryUsage;

  Assert.IsTrue(MemoryWithInterning < MemoryWithoutInterning,
  'String interning should reduce memory usage');
end;

end.
