unit DArrays;

interface

type
  TDArray = class(TObject)                                // Dynamic array class.
  private
    FData: Pointer;                                       // Pointer to array data.
    FCount: Integer;                                      // Element count.
    procedure SetCount(c: Integer);                       // Resize the array.
  protected
    FItemSize: Integer;                                   // Size of one item.
    procedure GetItem(i: Integer; var Result);            // Get one item.
    procedure SetItem(i: Integer; var value);             // Set one item.
  public
    constructor Create; virtual;                          // Overridable constructor.
    destructor Destroy; override;                         // Free memory.
    property ItemSize: Integer read FItemSize;            // Item size is read-only.
    property Count: Integer read FCount write SetCount;   // Write this to resize array.
    property Data: Pointer read FData;                    // Read-only pointer to data.
  end;

implementation

uses
  Windows, SysUtils;

constructor TDArray.Create;
begin

  inherited Create;
  // You have to set FItemSize in the constructor of your descendant classes!
  FItemSize := 1;
  // Start your array with room for a certain number of elements by setting Count.
  Count := 0;

end;

destructor TDArray.Destroy;
begin

  // Dispose of the array data.
  FreeMem(FData, FCount * FItemSize);
  inherited Destroy;

end;

procedure TDArray.SetCount(c: Integer);
begin

  // Resize the array by reallocating FData.
  FCount := c;
  ReAllocMem(FData, FCount * FItemSize);

end;

procedure TDArray.GetItem(i: Integer; var Result);
var
  p: Pointer;
begin

  { Retrieve an item using a little pointer arithmetic. Make sure SizeOf(Result)
    EXACTLY matches FItemSize!!! You have to write your own item retrieval method,
    accepting only parameters of the correct type and then calling GetItem(). This
    method is protected, so you HAVE to write a descendant class to interface
    GetItem(). }
  if i >= Count then raise Exception.Create('Array index out of bounds.')
  else begin
    p := FData;
    INC(Integer(p), i * FItemSize);
    CopyMemory(@Result, p, FItemSize);
  end;

end;

procedure TDArray.SetItem(i: Integer; var value);
var
  p: Pointer;
begin

  { Set an item. The comments on GetItem() apply here, too! }
  if i >= Count then SetCount(i+1);
  p := FData;
  INC(Integer(p), FItemSize * i);
  CopyMemory(p, @value, FItemSize);

end;

end.
