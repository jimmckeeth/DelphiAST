unit arrayboundexpression;

interface

const
  mlab = 4;
  mlog = 12;

type
  { An array bound is a constant EXPRESSION, not just a constant or a type name.
    OrdinalType decided on one token of lookahead and read `mlab` as a type name,
    so the whole unit failed to parse at the `+`. }
  TRanges = record
    iu: array[mlab + 1..mlog] of Integer;
    du: array[mlab * 2..mlog - 1, 0..mlab shl 1] of Byte;
  end;

  TSetOfExpression = set of mlab + 1..mlog;

implementation

end.
