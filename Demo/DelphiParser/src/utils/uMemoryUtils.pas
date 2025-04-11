unit uMemoryUtils;

interface

function MemoryUsed: Cardinal;

implementation

{$IFNDEF FPC}
uses
  FastMM4;
{$ENDIF}

{$IFNDEF FPC}
function MemoryUsed: Cardinal;
var
  st: TMemoryManagerState;
  sb: TSmallBlockTypeState;
begin
  GetMemoryManagerState(st);
  Result := st.TotalAllocatedMediumBlockSize + st.TotalAllocatedLargeBlockSize;
  for sb in st.SmallBlockTypeStates do
  Result := Result + sb.UseableBlockSize * sb.AllocatedBlockCount;
end;
{$ELSE}
function MemoryUsed: Cardinal;
begin
  Result := GetFPCHeapStatus.CurrHeapUsed;
end;
{$ENDIF}

end.
