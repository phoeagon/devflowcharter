{
   Copyright (C) 2006 The devFlowcharter project.
   The initial author of this file is Michal Domagala.

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation; either version 2
   of the License, or (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
}

unit LangDefinition;

interface

uses
{$IFDEF USE_CODEFOLDING}
    SynEditCodeFolding,
{$ENDIF}
    System.Classes, System.SysUtils, SizeEdit, SynEditHighlighter, YaccLib, DeclareList, UserFunction,
    Types, OmniXML, UserDataType;

type

{$IFDEF USE_CODEFOLDING}
   PFoldRegion = ^TFoldRegion;
   TFoldRegion = record
      Open,
      Close: string;
      AddClose,
      NoSubFolds,
      WholeWords: boolean;
      RegionType: TFoldRegionType;
   end;
{$ENDIF}

   TLangDefinition = class
   private
      FName,
      FCompilerKey,
      FCompilerNoMainKey,
      FCompilerFileEncodingKey,
      FVarTemplate,
      FConstTemplate,
      FDataTypesTemplate,
      FFunctionsTemplate,
      FProgramTemplate,
      FLibTemplate,
      FProgramHeaderTemplate: string;
      function GetVarTemplate: string;
      function GetConstTemplate: string;
      function GetDataTypesTemplate: string;
      function GetFunctionsTemplate: string;
      function GetProgramTemplate: string;
      function GetLibTemplate: string;
      function GetProgramHeaderTemplate: string;
      procedure InitBlockTemplates;
      procedure ImportBlockTemplates(ANode: IXMLNode);
   public
      CommentBegin, CommentEnd,
      DefaultExt,
      InputFunction,
      OutputFunction,
      LibraryExt,
      AssignOperator,
      VarEntry,
      VarEntryArray,
      VarEntryArraySize,
      VarEntryInit,
      VarEntryInitExtern,
      ConstEntry,
      ConstEntryArray,
      ConstTypeGeneric,
      ConstTypeNotGeneric,
      ElseLabel,
      LabelFontName,
      LabelRepeat,
      LabelWhile,
      LabelIf,
      LabelIfElse,
      LabelIn,
      LabelOut,
      LabelFor,
      LabelFuncCall,
      LabelInstr,
      LabelMultiInstr,
      LabelCase,
      LabelText,
      LabelFolder,
      LabelMain,
      ForDoAsc1,
      ForDoAsc2,
      ForDoDesc1,
      ForDoDesc2,
      CaseOfFirstValueTemplate,
      CaseOfValueTemplate,
      CaseOfDefaultValueTemplate,
      PointerTypeMask,
      MainFunctionTemplate,
      ProgramReturnTemplate,
      FunctionTemplate,
      FunctionHeaderTemplate,
      FunctionHeaderDescTemplate,
      ConstructorHeaderTemplate,
      FunctionHeaderTypeNone1,
      FunctionHeaderTypeNotNone1,
      FunctionHeaderTypeNone2,
      FunctionHeaderTypeNotNone2,
      FunctionHeaderDescParmMask,
      FunctionHeaderDescReturnMask,
      FunctionHeaderArgsEntryMask,
      FunctionHeaderArgsEntryRef,
      FunctionHeaderArgsEntryArray,
      FunctionHeaderArgsEntryDefault,
      FunctionHeaderArgsEntryRecord,
      FunctionHeaderArgsEntryEnum,
      UserTypeDesc,
      LibEntry,
      LibEntryList,
      DataTypeExternal,
      DataTypeTransExternal,
      DataTypeNotExternal,
      DataTypeIntMask,
      DataTypeRealMask,
      DataTypeOtherMask,
      DataTypeArrayMask,
      DataTypeUnboundedArrayMask,
      DataTypeRecordTemplate,
      DataTypeRecordFieldMask,
      DataTypeRecordFieldArrayMask,
      DataTypeEnumTemplate,
      DataTypeEnumEntryList,
      ProcedureLabelKey,
      FunctionLabelKey,
      ProgramLabelKey,
      ConstructorLabelKey,
      GlobalVarsLabelKey,
      GlobalConstsLabelKey,
      HighLighterVarName,
      FuncBrackets,
      VarExtern,
      VarTransExtern,
      VarNotExtern,
      ConstExtern,
      ConstTransExtern,
      ConstNotExtern,
      ConstIDSpecChars,
      DefFile,
      CompilerCommand,
      CompilerCommandNoMain,
      CompilerFileEncoding,
      InstrEnd,
      ForDoVarString,
      RepeatUntilDescTemplate,
      ForDoDescTemplate,
      ReturnDescTemplate,
      CaseOfDescTemplate,
      ExternalLabel,
      StaticLabel,
      RecordLabel,
      FunctionHeaderExternal,
      FunctionHeaderTransExternal,
      FunctionHeaderNotExternal,
      FunctionHeaderStatic,
      FunctionHeaderNotStatic,
      FunctionHeaderTypeArray,
      FunctionHeaderTypeNotArray: string;
      DecimalSeparator: char;
      LabelFontSize,
      FunctionHeaderArgsStripCount,
      VarEntryArraySizeStripCount,
      LibEntryListStripCount,
      DataTypeEnumEntryListStripCount: integer;
      HighLighter: TSynCustomHighlighter;
{$IFDEF USE_CODEFOLDING}
      FoldRegions: array of PFoldRegion;
{$ENDIF}
      Parser: TCustomParser;
      NativeDataTypes: array of PNativeDataType;
      NativeFunctions: array of PNativeFunction;
      KeyWords: TStringList;
      EnabledConsts,
      EnabledVars,
      EnabledCompiler,
      EnabledUserFunctionHeader,
      EnabledUserFunctionBody,
      EnabledUserDataTypes,
      EnabledUserDataTypeInt,
      EnabledUserDataTypeReal,
      EnabledUserDataTypeOther,
      EnabledUserDataTypeEnum,
      EnabledUserDataTypeArray,
      EnabledPointers,
      EnabledExplorer,
      EnabledCodeGenerator,
      EnabledMainProgram,
      CaseSensitiveSyntax,
      UpperCaseConstId,
      AllowEnumsInForLoop,
      AllowUserFunctionOverload,
      RepeatUntilAsDoWhile,
      ForDoVarList,
      CodeIncludeExternVarConst,
      CodeIncludeExternDataType,
      CodeIncludeExternFunction,
      AllowUnboundedArrays,
      AllowDuplicatedLibs,
      AllowTransExternVarConst,
      AllowTransExternFunction,
      AllowTransExternDataType: boolean;
      InOutCursorPos,
      FuncBracketsCursorPos: integer;
      BlockTemplates: array[TBlockType] of string;
      BeforeProgramGenerator: procedure;
      AfterProgramGenerator: procedure;
      ProgramHeaderSectionGenerator: procedure (ALines: TStringList);
      LibSectionGenerator: procedure (ALines: TStringList);
      UserDataTypeGenerator: procedure (ALines: TStringList; ADataType: TUserDataType);
      UserDataTypesSectionGenerator: procedure (ALines: TStringList);
      VarSectionGenerator: procedure (ALines: TStringList; AVarList: TVarDeclareList);
      ConstSectionGenerator: procedure (ALines: TStringList; AConstList: TConstDeclareList);
      UserFunctionGenerator: procedure (ALines: TStringList; AFunction: TUserFunction; ASkipBodyGen: boolean);
      UserFunctionsSectionGenerator: procedure (ALines: TStringList; ASkipBodyGenerate: boolean);
      MainFunctionSectionGenerator: procedure (ALines: TStringList; ADeep: integer);
      ProgramGenerator: procedure (ALines: TStringList);
      GetUserFuncDesc: function (AHeader: TUserFunctionHeader; AFullParams: boolean = True; AIncludeDesc: boolean = True): string;
      GetUserFuncHeaderDesc: function (AHeader: TUserFunctionHeader): string;
      GetUserTypeDesc: function (ADataType: TUserDataType): string;
      SetHLighterAttrs: procedure;
      GetPointerTypeName: function (const val: string): string;
      GetConstantType: function (const val: string; var AGenericType: string): integer;
      IsPointerType: function (const AName: string): boolean;
      GetOriginalType: function (const APtrType: string): string;
      AreTypesCompatible: function (AType1, AType2: integer): boolean;
      Parse: function (const AText: string; AParserMode: TYYMode): boolean;
      SkipFuncBodyGen: function: boolean;
      GetMainProgramDesc: function: string;
      property Name: string read FName;
      constructor Create;
      destructor Destroy; override;
      function ImportFromXML(ANode: IXMLNode; AImportMode: TImportMode): TError;
      function GetBlockTemplate(ABlockType: TBlockType): string;
      function GetArraySizes(ASizeEdit: TSizeEdit): string;
      procedure SaveCompilerData;
      procedure LoadCompilerData;
      function GetFileEncoding: TEncoding;
      property VarTemplate: string read GetVarTemplate;
      property ConstTemplate: string read GetConstTemplate;
      property DataTypesTemplate: string read GetDataTypesTemplate;
      property FunctionsTemplate: string read GetFunctionsTemplate;
      property ProgramTemplate: string read GetProgramTemplate;
      property LibTemplate: string read GetLibTemplate;
      property ProgramHeaderTemplate: string read GetProgramHeaderTemplate;
   end;

const
   BLOCK_TO_TEMPLATE_TAG_MAP: array[TBlockType] of string = ('', 'InstrTemplate', 'InstrTemplate', 'InputTemplate', 'OutputTemplate',
                                                             'FunctionCallTemplate', 'WhileTemplate', 'RepeatUntilTemplate', 'IfTemplate',
                                                             'IfElseTemplate', 'ForDoTemplate', 'CaseOfTemplate', 'FunctionBodyTemplate',
                                                             '', 'ReturnTemplate', 'TextTemplate', 'FolderTemplate');

implementation

uses
   Vcl.Forms, System.Rtti, Constants, Infrastructure, OmniXMLUtils;

constructor TLangDefinition.Create;
begin
   inherited;
   FName := '   ';
   DefaultExt := 'txt';
   LibraryExt := '.lib';
   AssignOperator := '=';
   ForDoVarString := '=';
   KeyWords := TStringList.Create;
   UpperCaseConstId := True;
   EnabledPointers := True;
   CompilerFileEncoding := 'ANSI';
   DecimalSeparator := '.';
   GlobalVarsLabelKey := 'GlobalVars';
   GlobalConstsLabelKey := 'GlobalConsts';
   EnabledUserDataTypeInt := True;
   EnabledUserDataTypeReal := True;
   EnabledUserDataTypeOther := True;
   EnabledUserDataTypeEnum := True;
   EnabledUserDataTypeArray := True;
   LabelFontName := FLOWCHART_DEFAULT_FONT_NAME;
   LabelFontSize := LABEL_DEFAULT_FONT_SIZE;
   ElseLabel := trnsManager.GetString('ElseLabel');
   InitBlockTemplates;
end;

destructor TLangDefinition.Destroy;
begin
   KeyWords.Free;
   KeyWords := nil;
   for var t in NativeDataTypes do
      Dispose(t);
   for var f in NativeFunctions do
      Dispose(f);
   NativeDataTypes := nil;
   NativeFunctions := nil;
   Parser.Free;
   Parser := nil;
   if not FName.Trim.IsEmpty then
      SaveCompilerData;
{$IFDEF USE_CODEFOLDING}
   for var fr in FoldRegions do
      Dispose(fr);
   FoldRegions := nil;
{$ENDIF}
   inherited;
end;

function TLangDefinition.ImportFromXML(ANode: IXMLNode; AImportMode: TImportMode): TError;
label
   skip;
begin

   result := errNone;
   var name := GetNodeTextStr(ANode, 'Name', '');
   if name.IsEmpty then
   begin
      GErr_Text := trnsManager.GetString('NameTagNotFound');
      Exit(errValidate);
   end;

   FName := name;

   FCompilerKey := 'CompilerPath_' + FName;
   FCompilerNoMainKey := 'CompilerPathNoMain_' + FName;
   FCompilerFileEncodingKey := 'CompilerFileEncoding_' + FName;

   ImportBlockTemplates(ANode);

   var node := FindNode(ANode, 'DecimalSeparator');
   if (node <> nil) and not node.Text.IsEmpty then
      DecimalSeparator := node.Text[1];

   var s3: T3Strings;
   node := FindNode(ANode, 'FunctionHeaderTypeModifier1');
   if node <> nil then
   begin
      s3 := T3Strings.Extract(node.Text);
      FunctionHeaderTypeNone1 := s3.S0;
      FunctionHeaderTypeNotNone1 := s3.S1;
   end;

   node := FindNode(ANode, 'FunctionHeaderTypeModifier2');
   if node <> nil then
   begin
      s3 := T3Strings.Extract(node.Text);
      FunctionHeaderTypeNone2 := s3.S0;
      FunctionHeaderTypeNotNone2 := s3.S1;
   end;

   node := FindNode(ANode, 'FunctionHeaderExternalModifier');
   if node <> nil then
   begin
      s3 := T3Strings.Extract(node.Text);
      FunctionHeaderExternal := s3.S0;
      FunctionHeaderNotExternal := s3.S1;
      FunctionHeaderTransExternal := s3.S2;
   end;

   node := FindNode(ANode, 'FunctionHeaderStaticModifier');
   if node <> nil then
   begin
      s3 := T3Strings.Extract(node.Text);
      FunctionHeaderStatic := s3.S0;
      FunctionHeaderNotStatic := s3.S1;
   end;

   node := FindNode(ANode, 'FunctionHeaderTypeArrayModifier');
   if node <> nil then
   begin
      s3 := T3Strings.Extract(node.Text);
      FunctionHeaderTypeArray := s3.S0;
      FunctionHeaderTypeNotArray := s3.S1;
   end;

   node := FindNode(ANode, 'VarExternModifier');
   if node <> nil then
   begin
      s3 := T3Strings.Extract(node.Text);
      VarExtern := s3.S0;
      VarNotExtern := s3.S1;
      VarTransExtern := s3.S2;
   end;

   node := FindNode(ANode, 'ConstExternModifier');
   if node <> nil then
   begin
      s3 := T3Strings.Extract(node.Text);
      ConstExtern := s3.S0;
      ConstNotExtern := s3.S1;
      ConstTransExtern := s3.S2;
   end;

   node := FindNode(ANode, 'ForDoTemplateModifier1');
   if node <> nil then
   begin
      s3 := T3Strings.Extract(node.Text);
      ForDoAsc1 := s3.S0;
      ForDoDesc1 := s3.S1;
   end;

   node := FindNode(ANode, 'ForDoTemplateModifier2');
   if node <> nil then
   begin
      s3 := T3Strings.Extract(node.Text);
      ForDoAsc2 := s3.S0;
      ForDoDesc2 := s3.S1;
   end;

   node := FindNode(ANode, 'DataTypeExternalModifier');
   if node <> nil then
   begin
      s3 := T3Strings.Extract(node.Text);
      DataTypeExternal := s3.S0;
      DataTypeNotExternal := s3.S1;
      DataTypeTransExternal := s3.S2;
   end;

   node := FindNode(ANode, 'ConstTypeModifier');
   if node <> nil then
   begin
      s3 := T3Strings.Extract(node.Text);
      ConstTypeNotGeneric := s3.S0;
      ConstTypeGeneric := s3.S1;
   end;

   node := FindNode(ANode, 'LabelFontName');
   if (node <> nil) and Screen.Fonts.Contains(node.Text) then
      LabelFontName := node.Text;

   CommentBegin                    := GetNodeTextStr(ANode, 'CommentBegin', CommentBegin);
   CommentEnd                      := GetNodeTextStr(ANode, 'CommentEnd', CommentEnd);
   InputFunction                   := GetNodeTextStr(ANode, 'InputFunction', InputFunction);
   OutputFunction                  := GetNodeTextStr(ANode, 'OutputFunction', OutputFunction);
   ProcedureLabelKey               := GetNodeTextStr(ANode, 'ProcedureLabelKey', ProcedureLabelKey);
   FunctionLabelKey                := GetNodeTextStr(ANode, 'FunctionLabelKey', FunctionLabelKey);
   ConstructorLabelKey             := GetNodeTextStr(ANode, 'ConstructorLabelKey', ConstructorLabelKey);
   ProgramLabelKey                 := GetNodeTextStr(ANode, 'ProgramLabelKey', ProgramLabelKey);
   GlobalVarsLabelKey              := GetNodeTextStr(ANode, 'GlobalVarsLabelKey', GlobalVarsLabelKey);
   GlobalConstsLabelKey            := GetNodeTextStr(ANode, 'GlobalConstsLabelKey', GlobalConstsLabelKey);
   HighLighterVarName              := GetNodeTextStr(ANode, 'HighLighterVarName', HighLighterVarName);
   ForDoVarString                  := GetNodeTextStr(ANode, 'ForDoVarString', ForDoVarString);
   ConstIDSpecChars                := GetNodeTextStr(ANode, 'ConstIDSpecChars', ConstIDSpecChars);
   FuncBrackets                    := GetNodeTextStr(ANode, 'FuncBrackets', FuncBrackets);
   InstrEnd                        := GetNodeTextStr(ANode, 'InstrEnd', InstrEnd);
   FVarTemplate                    := GetNodeTextStr(ANode, 'VarTemplate', FVarTemplate);
   FunctionTemplate                := GetNodeTextStr(ANode, 'FunctionTemplate', FunctionTemplate);
   FunctionHeaderTemplate          := GetNodeTextStr(ANode, 'FunctionHeaderTemplate', FunctionHeaderTemplate);
   FunctionHeaderDescTemplate      := GetNodeTextStr(ANode, 'FunctionHeaderDescTemplate', FunctionHeaderDescTemplate);
   FunctionHeaderDescParmMask      := GetNodeTextStr(ANode, 'FunctionHeaderDescParmMask', FunctionHeaderDescParmMask);
   FunctionHeaderDescReturnMask    := GetNodeTextStr(ANode, 'FunctionHeaderDescReturnMask', FunctionHeaderDescReturnMask);
   ConstructorHeaderTemplate       := GetNodeTextStr(ANode, 'ConstructorHeaderTemplate', ConstructorHeaderTemplate);
   PointerTypeMask                 := GetNodeTextStr(ANode, 'PointerTypeMask', PointerTypeMask);
   CaseOfValueTemplate             := GetNodeTextStr(ANode, 'CaseOfValueTemplate', CaseOfValueTemplate);
   CaseOfFirstValueTemplate        := GetNodeTextStr(ANode, 'CaseOfFirstValueTemplate', CaseOfFirstValueTemplate);
   CaseOfDefaultValueTemplate      := GetNodeTextStr(ANode, 'CaseOfDefaultValueTemplate', CaseOfDefaultValueTemplate);
   ElseLabel                       := GetNodeTextStr(ANode, 'ElseLabel', ElseLabel);
   LabelRepeat                     := GetNodeTextStr(ANode, 'LabelRepeat', LabelRepeat);
   LabelWhile                      := GetNodeTextStr(ANode, 'LabelWhile', LabelWhile);
   LabelFor                        := GetNodeTextStr(ANode, 'LabelFor', LabelFor);
   LabelCase                       := GetNodeTextStr(ANode, 'LabelCase', LabelCase);
   LabelIf                         := GetNodeTextStr(ANode, 'LabelIf', LabelIf);
   LabelIfElse                     := GetNodeTextStr(ANode, 'LabelIfElse', LabelIfElse);
   LabelFuncCall                   := GetNodeTextStr(ANode, 'LabelFuncCall', LabelFuncCall);
   LabelText                       := GetNodeTextStr(ANode, 'LabelText', LabelText);
   LabelFolder                     := GetNodeTextStr(ANode, 'LabelFolder', LabelFolder);
   LabelIn                         := GetNodeTextStr(ANode, 'LabelIn', LabelIn);
   LabelOut                        := GetNodeTextStr(ANode, 'LabelOut', LabelOut);
   LabelInstr                      := GetNodeTextStr(ANode, 'LabelInstr', LabelInstr);
   LabelMultiInstr                 := GetNodeTextStr(ANode, 'LabelMultiInstr', LabelMultiInstr);
   RepeatUntilDescTemplate         := GetNodeTextStr(ANode, 'RepeatUntilDescTemplate', RepeatUntilDescTemplate);
   ReturnDescTemplate              := GetNodeTextStr(ANode, 'ReturnDescTemplate', ReturnDescTemplate);
   ForDoDescTemplate               := GetNodeTextStr(ANode, 'ForDoDescTemplate', ForDoDescTemplate);
   CaseOfDescTemplate              := GetNodeTextStr(ANode, 'CaseOfDescTemplate', CaseOfDescTemplate);
   MainFunctionTemplate            := GetNodeTextStr(ANode, 'MainFunctionTemplate', MainFunctionTemplate);
   ProgramReturnTemplate           := GetNodeTextStr(ANode, 'ProgramReturnTemplate', ProgramReturnTemplate);
   FDataTypesTemplate              := GetNodeTextStr(ANode, 'DataTypesTemplate', FDataTypesTemplate);
   FFunctionsTemplate              := GetNodeTextStr(ANode, 'FunctionsTemplate', FFunctionsTemplate);
   FProgramTemplate                := GetNodeTextStr(ANode, PROGRAM_TEMPLATE_TAG, FProgramTemplate);
   DataTypeIntMask                 := GetNodeTextStr(ANode, 'DataTypeIntMask', DataTypeIntMask);
   DataTypeRealMask                := GetNodeTextStr(ANode, 'DataTypeRealMask', DataTypeRealMask);
   DataTypeOtherMask               := GetNodeTextStr(ANode, 'DataTypeOtherMask', DataTypeOtherMask);
   DataTypeRecordTemplate          := GetNodeTextStr(ANode, 'DataTypeRecordTemplate', DataTypeRecordTemplate);
   DataTypeEnumTemplate            := GetNodeTextStr(ANode, 'DataTypeEnumTemplate', DataTypeEnumTemplate);
   DataTypeEnumEntryList           := GetNodeTextStr(ANode, 'DataTypeEnumEntryList', DataTypeEnumEntryList);
   DataTypeArrayMask               := GetNodeTextStr(ANode, 'DataTypeArrayMask', DataTypeArrayMask);
   DataTypeUnboundedArrayMask      := GetNodeTextStr(ANode, 'DataTypeUnboundedArrayMask', DataTypeUnboundedArrayMask);
   DataTypeRecordFieldMask         := GetNodeTextStr(ANode, 'DataTypeRecordFieldMask', DataTypeRecordFieldMask);
   DataTypeRecordFieldArrayMask    := GetNodeTextStr(ANode, 'DataTypeRecordFieldArrayMask', DataTypeRecordFieldArrayMask);
   FConstTemplate                  := GetNodeTextStr(ANode, 'ConstTemplate', FConstTemplate);
   ConstEntry                      := GetNodeTextStr(ANode, 'ConstEntry', ConstEntry);
   ConstEntryArray                 := GetNodeTextStr(ANode, 'ConstEntryArray', ConstEntryArray);
   VarEntryInit                    := GetNodeTextStr(ANode, 'VarEntryInit', VarEntryInit);
   VarEntryInitExtern              := GetNodeTextStr(ANode, 'VarEntryInitExtern', VarEntryInitExtern);
   VarEntry                        := GetNodeTextStr(ANode, 'VarEntry', VarEntry);
   VarEntryArray                   := GetNodeTextStr(ANode, 'VarEntryArray', VarEntryArray);
   VarEntryArraySize               := GetNodeTextStr(ANode, 'VarEntryArraySize', VarEntryArraySize);
   FLibTemplate                    := GetNodeTextStr(ANode, 'LibTemplate', FLibTemplate);
   LibEntry                        := GetNodeTextStr(ANode, 'LibEntry', LibEntry);
   LibEntryList                    := GetNodeTextStr(ANode, 'LibEntryList', LibEntryList);
   FunctionHeaderArgsEntryArray    := GetNodeTextStr(ANode, 'FunctionHeaderArgsEntryArray', FunctionHeaderArgsEntryArray);
   FunctionHeaderArgsEntryDefault  := GetNodeTextStr(ANode, 'FunctionHeaderArgsEntryDefault', FunctionHeaderArgsEntryDefault);
   FunctionHeaderArgsEntryRef      := GetNodeTextStr(ANode, 'FunctionHeaderArgsEntryRef', FunctionHeaderArgsEntryRef);
   FunctionHeaderArgsEntryRecord   := GetNodeTextStr(ANode, 'FunctionHeaderArgsEntryRecord', FunctionHeaderArgsEntryRecord);
   FunctionHeaderArgsEntryEnum     := GetNodeTextStr(ANode, 'FunctionHeaderArgsEntryEnum', FunctionHeaderArgsEntryEnum);
   FunctionHeaderArgsEntryMask     := GetNodeTextStr(ANode, 'FunctionHeaderArgsEntryMask', FunctionHeaderArgsEntryMask);
   FProgramHeaderTemplate          := GetNodeTextStr(ANode, 'ProgramHeaderTemplate', FProgramHeaderTemplate);
   DefaultExt                      := GetNodeTextStr(ANode, 'DefaultExt', DefaultExt);
   LibraryExt                      := GetNodeTextStr(ANode, 'LibraryExt', LibraryExt);
   AssignOperator                  := GetNodeTextStr(ANode, 'AssignOperator', AssignOperator);
   UserTypeDesc                    := GetNodeTextStr(ANode, 'UserTypeDesc', UserTypeDesc);
   ExternalLabel                   := GetNodeTextStr(ANode, 'ExternalLabel', ExternalLabel);
   StaticLabel                     := GetNodeTextStr(ANode, 'StaticLabel', StaticLabel);
   RecordLabel                     := GetNodeTextStr(ANode, 'RecordLabel', RecordLabel);

   FuncBracketsCursorPos           := GetNodeTextInt(ANode, 'FuncBracketsCursorPos', FuncBracketsCursorPos);
   LabelFontSize                   := GetNodeTextInt(ANode, 'LabelFontSize', LabelFontSize);
   VarEntryArraySizeStripCount     := GetNodeTextInt(ANode, 'VarEntryArraySizeStripCount', VarEntryArraySizeStripCount);
   LibEntryListStripCount          := GetNodeTextInt(ANode, 'LibEntryListStripCount', LibEntryListStripCount);
   FunctionHeaderArgsStripCount    := GetNodeTextInt(ANode, 'FunctionHeaderArgsStripCount', FunctionHeaderArgsStripCount);
   InOutCursorPos                  := GetNodeTextInt(ANode, 'InOutCursorPos', InOutCursorPos);
   DataTypeEnumEntryListStripCount := GetNodeTextInt(ANode, 'DataTypeEnumEntryListStripCount', DataTypeEnumEntryListStripCount);

   ForDoVarList                    := GetNodeTextBool(ANode, 'ForDoVarList', ForDoVarList);
   EnabledPointers                 := GetNodeTextBool(ANode, 'EnabledPointers', EnabledPointers);
   RepeatUntilAsDoWhile            := GetNodeTextBool(ANode, 'RepeatUntilAsDoWhile', RepeatUntilAsDoWhile);
   EnabledConsts                   := GetNodeTextBool(ANode, 'EnabledConsts', EnabledConsts);
   EnabledVars                     := GetNodeTextBool(ANode, 'EnabledVars', EnabledVars);
   EnabledCompiler                 := GetNodeTextBool(ANode, 'EnabledCompiler', EnabledCompiler);
   EnabledUserFunctionHeader       := GetNodeTextBool(ANode, 'EnabledUserFunctionHeader', EnabledUserFunctionHeader);
   EnabledUserFunctionBody         := GetNodeTextBool(ANode, 'EnabledUserFunctionBody', EnabledUserFunctionBody);
   EnabledUserDataTypes            := GetNodeTextBool(ANode, 'EnabledUserDataTypes', EnabledUserDataTypes);
   EnabledUserDataTypeInt          := GetNodeTextBool(ANode, 'EnabledUserDataTypeInt', EnabledUserDataTypeInt);
   EnabledUserDataTypeReal         := GetNodeTextBool(ANode, 'EnabledUserDataTypeReal', EnabledUserDataTypeReal);
   EnabledUserDataTypeOther        := GetNodeTextBool(ANode, 'EnabledUserDataTypeOther', EnabledUserDataTypeOther);
   EnabledUserDataTypeArray        := GetNodeTextBool(ANode, 'EnabledUserDataTypeArray', EnabledUserDataTypeArray);
   EnabledUserDataTypeEnum         := GetNodeTextBool(ANode, 'EnabledUserDataTypeEnum', EnabledUserDataTypeEnum);
   EnabledExplorer                 := GetNodeTextBool(ANode, 'EnabledExplorer', EnabledExplorer);
   EnabledCodeGenerator            := GetNodeTextBool(ANode, 'EnabledCodeGenerator', EnabledCodeGenerator);
   EnabledMainProgram              := GetNodeTextBool(ANode, 'EnabledMainProgram', EnabledMainProgram);
   CaseSensitiveSyntax             := GetNodeTextBool(ANode, 'CaseSensitiveSyntax', CaseSensitiveSyntax);
   UpperCaseConstId                := GetNodeTextBool(ANode, 'UpperCaseConstId', UpperCaseConstId);
   AllowEnumsInForLoop             := GetNodeTextBool(ANode, 'AllowEnumsInForLoop', AllowEnumsInForLoop);
   AllowUserFunctionOverload       := GetNodeTextBool(ANode, 'AllowUserFunctionOverload', AllowUserFunctionOverload);
   AllowUnboundedArrays            := GetNodeTextBool(ANode, 'AllowUnboundedArrays', AllowUnboundedArrays);
   AllowDuplicatedLibs             := GetNodeTextBool(ANode, 'AllowDuplicatedLibs', AllowDuplicatedLibs);
   AllowTransExternVarConst        := GetNodeTextBool(ANode, 'AllowTransExternVarConst', AllowTransExternVarConst);
   AllowTransExternFunction        := GetNodeTextBool(ANode, 'AllowTransExternFunction', AllowTransExternFunction);
   AllowTransExternDataType        := GetNodeTextBool(ANode, 'AllowTransExternDataType', AllowTransExternDataType);
   CodeIncludeExternVarConst       := GetNodeTextBool(ANode, 'CodeIncludeExternVarConst', CodeIncludeExternVarConst);
   CodeIncludeExternDataType       := GetNodeTextBool(ANode, 'CodeIncludeExternDataType', CodeIncludeExternDataType);
   CodeIncludeExternFunction       := GetNodeTextBool(ANode, 'CodeIncludeExternFunction', CodeIncludeExternFunction);

   node := FindNode(ANode, 'NativeDataTypes');
   if node <> nil then
   begin
      var datatypeNodes := FilterNodes(node, 'DataType');
      var dnode := datatypeNodes.NextNode;
      while dnode <> nil do
      begin
         var originalType: PNativeDataType := nil;
         name := dnode.Text.Trim;
         if name.IsEmpty then
            goto skip;
         var kind := TRttiEnumerationType.GetValue<TDataTypeKind>('tp' + GetNodeAttrStr(dnode, 'kind', 'Other'));
         if Ord(kind) < 0 then
            kind := tpOther;
         if kind = tpPtr then
         begin
            if not EnabledPointers then
               goto skip;
            var val := GetNodeAttrStr(dnode, 'origtype', '').Trim;
            for var t in NativeDataTypes do
            begin
               if SameText(val, t.Name) then
               begin
                  originalType := t;
                  break;
               end;
            end;
         end;
         var dataType := New(PNativeDataType);
         dataType.Name := name;
         dataType.Kind := kind;
         if originalType = nil then
            originalType := dataType;
         dataType.OriginalType := originalType;
         dataType.IsGeneric := GetNodeAttrBool(dnode, 'generic', False);
         dataType.Lib := GetNodeAttrStr(dnode, 'library', '');
         NativeDataTypes := NativeDataTypes + [dataType];
         skip:
         dnode := datatypeNodes.NextNode;
      end;
   end;
   node := FindNode(ANode, 'KeyWords');
   if node <> nil then
   begin
      KeyWords.Sorted := False;
      KeyWords.CaseSensitive := CaseSensitiveSyntax;
      GetNodesText(node, 'KeyWord', KeyWords);
      KeyWords.Sort;
   end;
   node := FindNode(ANode, 'NativeFunctions');
   if node <> nil then
   begin
      var functionNodes := FilterNodes(node, 'Function');
      var fnode := functionNodes.NextNode;
      while fnode <> nil do
      begin
         name := fnode.Text.Trim;
         if not name.IsEmpty then
         begin
            var nativeFunction := New(PNativeFunction);
            nativeFunction.Name := name;
            nativeFunction.Brackets := GetNodeAttrStr(fnode, 'brackets', '');
            nativeFunction.BracketsCursorPos := GetNodeAttrInt(fnode, 'bracketsCursorPos', 0);
            nativeFunction.Caption := GetNodeAttrStr(fnode, 'caption', '').Trim;
            nativeFunction.Hint := GetNodeAttrStr(fnode, 'hint', '').Trim;
            nativeFunction.Lib := GetNodeAttrStr(fnode, 'library', '').Trim;
            NativeFunctions := NativeFunctions + [nativeFunction];
         end;
         fnode := functionNodes.NextNode;
      end;
   end;
{$IFDEF USE_CODEFOLDING}
   node := FindNode(ANode, 'FoldRegions');
   if node <> nil then
   begin
      var foldRegionNodes := FilterNodes(node, 'FoldRegion');
      var rnode := foldRegionNodes.NextNode;
      while rnode <> nil do
      begin
         var foldRegion := New(PFoldRegion);
         foldRegion.Open := GetNodeAttrStr(FindNode(rnode, 'Open'), 'Keyword', '');
         foldRegion.Close := GetNodeAttrStr(FindNode(rnode, 'Close'), 'Keyword', '');
         foldRegion.AddClose := GetNodeAttrBool(rnode, 'AddClose', False);
         foldRegion.NoSubFolds := GetNodeAttrBool(rnode, 'NoSubFolds', True);
         foldRegion.WholeWords := GetNodeAttrBool(rnode, 'WholeWords', True);
         if GetNodeAttrStr(rnode, 'Type', '') = 'rtChar' then
            foldRegion.RegionType := rtChar
         else
            foldRegion.RegionType := rtKeyword;
         FoldRegions := FoldRegions + [foldRegion];
         rnode := foldRegionNodes.NextNode;
      end;
   end;
{$ENDIF}
end;

procedure TLangDefinition.LoadCompilerData;
begin
   var sFile := GSettings.SettingsFile;
   CompilerCommand := sFile.ReadString(SETTINGS_SECTION, FCompilerKey, '');
   CompilerCommandNoMain := sFile.ReadString(SETTINGS_SECTION, FCompilerNoMainKey, '');
   CompilerFileEncoding := sFile.ReadString(SETTINGS_SECTION, FCompilerFileEncodingKey, '');
end;

procedure TLangDefinition.SaveCompilerData;
begin
   var sFile := GSettings.SettingsFile;
   sFile.WriteString(SETTINGS_SECTION, FCompilerKey, CompilerCommand);
   sFile.WriteString(SETTINGS_SECTION, FCompilerNoMainKey, CompilerCommandNoMain);
   sFile.WriteString(SETTINGS_SECTION, FCompilerFileEncodingKey, CompilerFileEncoding);
end;

function TLangDefinition.GetBlockTemplate(ABlockType: TBlockType): string;
begin
   result := BlockTemplates[ABlockType];
end;

function TLangDefinition.GetArraySizes(ASizeEdit: TSizeEdit): string;
begin
   result := '';
   if ASizeEdit <> nil then
   begin
      for var dim in ASizeEdit.GetDimensions do
         result := result + Format(VarEntryArraySize, [dim]);
      if VarEntryArraySizeStripCount > 0 then
         SetLength(result, result.Length - VarEntryArraySizeStripCount);
   end;
end;

function TLangDefinition.GetFileEncoding: TEncoding;
begin
   if CompilerFileEncoding = 'ASCII' then
      result := TEncoding.ASCII
   else if CompilerFileEncoding = 'UTF-7' then
      result := TEncoding.UTF7
   else if CompilerFileEncoding = 'UTF-8' then
      result := TEncoding.UTF8
   else if CompilerFileEncoding = 'Unicode' then
      result := TEncoding.Unicode
   else if CompilerFileEncoding = 'BE Unicode' then
      result := TEncoding.BigEndianUnicode
   else
      result := TEncoding.ANSI;
end;

function TLangDefinition.GetVarTemplate: string;
begin
   result := TInfra.ReplaceXMLIndents(FVarTemplate);
end;

function TLangDefinition.GetConstTemplate: string;
begin
   result := TInfra.ReplaceXMLIndents(FConstTemplate);
end;

function TLangDefinition.GetDataTypesTemplate: string;
begin
   result := TInfra.ReplaceXMLIndents(FDataTypesTemplate);
end;

function TLangDefinition.GetFunctionsTemplate: string;
begin
   result := TInfra.ReplaceXMLIndents(FFunctionsTemplate);
end;

function TLangDefinition.GetProgramTemplate: string;
begin
   result := TInfra.ReplaceXMLIndents(FProgramTemplate);
end;

function TLangDefinition.GetLibTemplate: string;
begin
   result := TInfra.ReplaceXMLIndents(FLibTemplate);
end;

function TLangDefinition.GetProgramHeaderTemplate: string;
begin
   result := TInfra.ReplaceXMLIndents(FProgramHeaderTemplate);
end;

procedure TLangDefinition.InitBlockTemplates;
begin
   for var blockType := Low(TBlockType) to High(TBlockType) do
      BlockTemplates[blockType] := trnsManager.GetString(BLOCK_TO_TEMPLATE_TAG_MAP[blockType]);
end;

procedure TLangDefinition.ImportBlockTemplates(ANode: IXMLNode);
begin
   for var blockType := Low(TBlockType) to High(TBlockType) do
      BlockTemplates[blockType] := GetNodeTextStr(ANode, BLOCK_TO_TEMPLATE_TAG_MAP[blockType], '');
end;

end.
