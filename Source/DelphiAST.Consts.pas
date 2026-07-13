unit DelphiAST.Consts;

interface

type
  TSyntaxNodeType = (
    ntAddr,
    ntDoubleAddr,
    ntDeref,
    ntGeneric,
    ntIndexed,
    ntDot,
    ntCall,
    ntUnaryMinus,
    ntNot,
    ntMul,
    ntFDiv,
    ntDiv,
    ntMod,
    ntAnd,
    ntShl,
    ntShr,
    ntAs,
    ntAdd,
    ntSub,
    ntOr,
    ntXor,
    ntEqual,
    ntNotEqual,
    ntLower,
    ntGreater,
    ntLowerEqual,
    ntGreaterEqual,
    ntIn,
    ntNotIn,
    ntIs,
    ntIsNot,

    // Allow the use of [ntStrictPrivate..ntAutomated].
    ntStrictPrivate,
    ntPrivate,
    ntStrictProtected,
    ntProtected,
    ntPublic,
    ntPublished,
    ntAutomated,

    ntUnknown,
    ntAbsolute,
    ntAlignmentParam,
    ntAnonymousMethod,
    ntAnonymousMethodType,
    ntArguments,
    ntAsmFragment,
    ntAsmStatement,
    ntAssign,
    ntAt,
    ntAttribute,
    ntAttributes,
    ntBounds,
    ntCase,
    ntCaseElse,
    ntCaseLabel,
    ntCaseLabels,
    ntCaseSelector,
    ntClassConstraint,
    ntCompilerDirective,
    ntConstant,
    ntConstants,
    ntConstraints,
    ntConstructorConstraint,
    ntContains,
    ntDefault,
    ntDependency,
    ntDeprecated,
    ntDimension,
    ntDownTo,
    ntElement,
    ntElse,
    ntEmptyStatement,
    ntEnum,
    ntExcept,
    ntExceptElse,
    ntExceptionHandler,
    ntExperimental,
    ntExports,
    ntExpression,
    ntExpressions,
    ntExternal,
    ntExternalName,
    ntField,
    ntFields,
    ntFinalization,
    ntFinally,
    ntFor,
    ntFrom,
    ntGoto,
    ntGuid,
    ntHelper,
    ntIdentifier,
    ntIf,
    ntImplementation,
    ntImplements,
    ntIndex,
    ntInherited,
    ntInitialization,
    ntInterface,
    ntLabel,
    ntLabeledStatement,
    ntLHS,
    ntLibrary,
    ntLiteral,
    ntMessage,
    ntMethod,
    ntName,
    ntNamedArgument,
    ntPackage,
    ntParameter,
    ntParameters,
    ntPlatform,
    ntPositionalArgument,
    ntProgram,
    ntProperty,
    ntRaise,
    ntRead,
    ntRecordConstant,
    ntRecordConstraint,
    ntRecordVariant,
    ntRepeat,
    ntRequires,
    ntResident,
    ntResolutionClause,
    ntResourceString,
    ntReturnType,
    ntRHS,
    ntRoundClose,
    ntRoundOpen,
    ntSet,
    ntStatement,
    ntStatements,
    ntSubrange,
    ntTernaryOp,
    ntThen,
    ntTo,
    ntTry,
    ntType,
    ntTypeArgs,
    ntTypeDecl,
    ntTypeParam,
    ntTypeParams,
    ntTypeSection,
    ntValue,
    ntVariable,
    ntVariables,
    ntVariantSection,
    ntVariantTag,
    ntUnit,
    ntUses,
    ntWhile,
    ntWith,
    ntWrite,

    ntAnsiComment,
    ntBorComment,
    ntSlashesComment
  );

  TSyntaxNodeTypes = set of TSyntaxNodeType;

  TAttributeName = (
    anType,
    anClass,
    anForwarded,
    anKind,
    anName,
    anVisibility,
    anCallingConvention,
    anPath,
    anMethodBinding,
    anReintroduce,
    anOverload,
    anAbstract,
    anInline,
    anAlign
  );

  TAttributeNames = set of TAttributeName;

type
  SyntaxNodeNames = class
  strict private
    class var FData: array[TSyntaxNodeType] of string;
    class function GetItem(const index: TSyntaxNodeType): string; static; inline;
    class constructor Init;
  public
    class property Items[const index: TSyntaxNodeType]: string read GetItem; default;
  end;

const
  AttributeNameStrings: array[TAttributeName] of string = (
    'type',
    'class',
    'forwarded',
    'kind',
    'name',
    'visibility',
    'callingconvention',
    'path',
    'methodbinding',
    'reintroduce',
    'overload',
    'abstract',
    'inline',
    'align'
  );

implementation

uses
  SysUtils, TypInfo;

{ TSyntaxNodeNames }

class function SyntaxNodeNames.GetItem(const index: TSyntaxNodeType): string;
begin
  Result := FData[index];
end;

class constructor SyntaxNodeNames.Init;
var
  Value: TSyntaxNodeType;
begin
  for Value := Low(TSyntaxNodeType) to High(TSyntaxNodeType) do
    FData[Value] := Copy(LowerCase(GetEnumName(TypeInfo(TSyntaxNodeType), Ord(Value))), 3);
end;

end.
