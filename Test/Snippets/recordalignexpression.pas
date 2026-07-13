unit recordalignexpression;

interface

type
  TAlignedRecord = record
    Value: Integer;
  end align SizeOf(Integer) * 2;

implementation

end.
