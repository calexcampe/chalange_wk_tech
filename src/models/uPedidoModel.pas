unit uPedidoModel;

interface

uses
  System.Generics.Collections, uPedidoItemModel;

type
  TPedidoModel = class
  public
    Numero: Integer;
    Data: TDate;
    CodCliente: Integer;
    ValorTotal: Double;

    Itens: TObjectList<TPedidoItemModel>;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TPedidoModel }

constructor TPedidoModel.Create;
begin
  Itens := TObjectList<TPedidoItemModel>.Create;
end;

destructor TPedidoModel.Destroy;
begin
  Itens.Free;
  inherited;
end;

end.

