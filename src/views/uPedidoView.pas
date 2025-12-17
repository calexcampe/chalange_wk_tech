unit uPedidoView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids,
  Vcl.Buttons, uPedidoController, uPedidoItemModel, uPedidoModel,
  uClienteModel, uProdutoModel, FireDAC.UI.Intf, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Intf, FireDAC.Comp.UI, FireDAC.Phys.MySQLDef, FireDAC.Phys,
  FireDAC.Phys.MySQL;

type
  TfrmPedidoView = class(TForm)
    edtCodCliente: TEdit;
    edtNomeCliente: TEdit;
    btnBuscarCliente: TBitBtn;

    edtCodProduto: TEdit;
    edtQtd: TEdit;
    edtVrUnit: TEdit;
    btnInserirItem: TBitBtn;

    sgItens: TStringGrid;

    edtTotal: TEdit;
    Label5: TLabel;

    btnGravar: TBitBtn;
    btnCarregar: TBitBtn;
    btnCancelar: TBitBtn;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    edtDescricaoProduto: TEdit;

    procedure FormCreate(Sender: TObject);
    procedure btnBuscarClienteClick(Sender: TObject);
    procedure btnInserirItemClick(Sender: TObject);
    procedure sgItensKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnGravarClick(Sender: TObject);
    procedure btnCarregarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure edtCodClienteChange(Sender: TObject);
    procedure edtCodProdutoExit(Sender: TObject);

  private
    FController: TPedidoController;
    FIndexEdicao: Integer; { <--- Controla se está inserindo (-1) ou editando (>=0) }

    procedure AtualizarGrid;
    procedure LimparCamposProduto;
    procedure LimparPedido;
    procedure AtualizarBotoes;
  public
  end;

var
  frmPedidoView: TfrmPedidoView;

implementation

{$R *.dfm}

procedure TfrmPedidoView.FormCreate(Sender: TObject);
begin
  FController := TPedidoController.Create;
  FIndexEdicao := -1; // Inicializa sem edição

  AtualizarBotoes;

  sgItens.ColCount := 5;
  sgItens.RowCount := 1;
  sgItens.Options := sgItens.Options + [goRowSelect];
  sgItens.Options := sgItens.Options - [goEditing];

  sgItens.Cells[0,0] := 'Código';
  sgItens.Cells[1,0] := 'Descrição';
  sgItens.Cells[2,0] := 'Qtd';
  sgItens.Cells[3,0] := 'Vlr Unit';
  sgItens.Cells[4,0] := 'Vlr Total';
  sgItens.TabStop := True;
end;

procedure TfrmPedidoView.edtCodProdutoExit(Sender: TObject);
var
  Prod: TProdutoModel;
  Cod: Integer;
begin
  if Trim(edtCodProduto.Text) = '' then Exit;

  Cod := StrToIntDef(edtCodProduto.Text, 0);
  Prod := FController.BuscarProduto(Cod);

  try
    if Assigned(Prod) then
    begin
      if Assigned(edtDescricaoProduto) then
        edtDescricaoProduto.Text := Prod.Descricao;

      edtVrUnit.Text := FloatToStr(Prod.PrecoVenda);

      edtQtd.SetFocus;
    end
    else
    begin
      ShowMessage('Produto não encontrado!');
      edtCodProduto.SetFocus;
      if Assigned(edtDescricaoProduto) then edtDescricaoProduto.Clear;
      edtVrUnit.Clear;
    end;
  finally
    // Libera a memória do objeto criado pelo Controller
    if Assigned(Prod) then Prod.Free;
  end;
end;


procedure TfrmPedidoView.btnBuscarClienteClick(Sender: TObject);
var
  C: TClienteModel;
begin
  C := FController.BuscarCliente(StrToIntDef(edtCodCliente.Text, 0));

  try
    if C = nil then
    begin
      ShowMessage('Cliente não encontrado!');
      edtNomeCliente.Clear;
      Exit;
    end;

    edtNomeCliente.Text := C.Nome;

    FController.Pedido.CodCliente := C.Codigo;
    AtualizarBotoes;
  finally
    if Assigned(C) then C.Free;
  end;
end;

procedure TfrmPedidoView.btnInserirItemClick(Sender: TObject);
var
  CodProd: Integer;
  Qtd, VlrUnit: Double;
begin
  CodProd := StrToIntDef(edtCodProduto.Text, 0);
  Qtd     := StrToFloatDef(edtQtd.Text, 0);
  VlrUnit := StrToFloatDef(edtVrUnit.Text, 0);

  // Validação simples de Produto
  if (CodProd <= 0) then
  begin
    ShowMessage('Informe o código do produto');
    edtCodProduto.SetFocus;
    Exit;
  end;

  if (Qtd <= 0) or (VlrUnit <= 0) then
  begin
    ShowMessage('Informe quantidade e valor unitário');
    Exit;
  end;

  if FIndexEdicao >= 0 then
  begin
    // MODO EDIÇÃO: Apenas atualiza o item existente na lista
    FController.EditarItem(FIndexEdicao, Qtd, VlrUnit);
    edtCodProduto.Enabled := false;
  end
  else
  begin
    // MODO INSERÇÃO: Adiciona novo
    edtCodProduto.Enabled := true;
    FController.AdicionarItem(CodProd, Qtd, VlrUnit);
  end;

  AtualizarGrid;

  edtTotal.Text := CurrToStrF(Currency(FController.Pedido.ValorTotal), ffCurrency, 2);

  LimparCamposProduto;
  sgItens.SetFocus;
end;

procedure TfrmPedidoView.edtCodClienteChange(Sender: TObject);
begin
  AtualizarBotoes;
end;

procedure TfrmPedidoView.AtualizarGrid;
var
  I: Integer;
  Item: TPedidoItemModel;
  Prod: TProdutoModel;
begin
  if FController.Pedido.Itens.Count > 0 then
    sgItens.RowCount := FController.Pedido.Itens.Count + 1
  else
    sgItens.RowCount := 1;

  for I := 0 to FController.Pedido.Itens.Count - 1 do
  begin
    Item := FController.Pedido.Itens[I];

    // Busca produto para exibir descrição
    Prod := FController.BuscarProduto(Item.CodigoProduto);
    try
      sgItens.Cells[0, I+1] := Item.CodigoProduto.ToString;

      if Prod <> nil then
        sgItens.Cells[1, I+1] := Prod.Descricao
      else
        sgItens.Cells[1, I+1] := 'Produto n/d';

      sgItens.Cells[2, I+1] := FloatToStr(Item.Quantidade);
      sgItens.Cells[3, I+1] := FloatToStr(Item.VrUnitario);
      sgItens.Cells[4, I+1] := FloatToStr(Item.VrTotal);
    finally
      if Assigned(Prod) then Prod.Free;
    end;
  end;
end;

procedure TfrmPedidoView.LimparCamposProduto;
begin
  edtCodProduto.Enabled := true;
  edtCodProduto.Clear;
  if Assigned(edtDescricaoProduto) then edtDescricaoProduto.Clear;
  edtQtd.Clear;
  edtVrUnit.Clear;

  // Reseta estado para Inserção
  FIndexEdicao := -1;
  btnInserirItem.Caption := 'Inserir Item';

  edtCodProduto.SetFocus;
end;

procedure TfrmPedidoView.sgItensKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Index: Integer;
begin
  Index := sgItens.Row - 1;
  if Index < 0 then Exit;

  // DELETE - Remover item
  if Key = VK_DELETE then
  begin
    if (MessageDlg('Remover item?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    begin
      // Se estiver editando este item, cancela a edição
      if FIndexEdicao = Index then LimparCamposProduto;

      FController.RemoverItem(Index);
      AtualizarGrid;
      edtTotal.Text := FloatToStr(FController.Pedido.ValorTotal);
    end;
  end;

  // ENTER → Carregar para Editar
  if Key = VK_RETURN then
  begin
    FIndexEdicao := Index;

    // Carrega dados do Grid para os Edits
    edtCodProduto.Text := sgItens.Cells[0, sgItens.Row];

    if Assigned(edtDescricaoProduto) then
       edtDescricaoProduto.Text := sgItens.Cells[1, sgItens.Row];

    edtQtd.Text        := sgItens.Cells[2, sgItens.Row];
    edtVrUnit.Text     := sgItens.Cells[3, sgItens.Row];

    // Muda caption do botão para usuário perceber
    btnInserirItem.Caption := 'Salvar Alteração';
    edtCodProduto.Enabled := false;

    edtQtd.SetFocus;
  end;
end;

procedure TfrmPedidoView.btnGravarClick(Sender: TObject);
begin
  if FController.Pedido.CodCliente = 0 then
  begin
    ShowMessage('Informe o cliente antes de gravar o pedido.');
    edtCodCliente.SetFocus;
    Exit;
  end;

  if FController.Pedido.Itens.Count = 0 then
  begin
    ShowMessage('Informe ao menos um produto no pedido.');
    edtCodProduto.SetFocus;
    Exit;
  end;

  // Proteção: Se estiver editando, avisa o usuário
  if FIndexEdicao >= 0 then
  begin
    if MessageDlg('Há um item em edição. Deseja descartar a edição e gravar?',
       mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;

    LimparCamposProduto;
  end;

  try
    FController.GravarPedido;

    edtTotal.Text := CurrToStrF(Currency(FController.Pedido.ValorTotal), ffCurrency, 2);

    ShowMessage('Pedido gravado com sucesso! Número: ' + FController.Pedido.Numero.ToString);

    LimparPedido;
  except
    on E: Exception do
      ShowMessage('Erro: ' + E.Message);
  end;
end;

procedure TfrmPedidoView.btnCarregarClick(Sender: TObject);
var
  Num: Integer;
  P: TPedidoModel;
begin
  if not TryStrToInt(InputBox('Carregar Pedido', 'Número do pedido:', ''), Num) then Exit;

  P := FController.CarregarPedido(Num);

  if P = nil then
  begin
    ShowMessage('Pedido não encontrado!');
    Exit;
  end;

  edtCodCliente.Text := P.CodCliente.ToString;
  btnBuscarClienteClick(nil); // Atualiza nome

  AtualizarGrid;
  edtTotal.Text := FloatToStr(P.ValorTotal);
  AtualizarBotoes;
end;

procedure TfrmPedidoView.btnCancelarClick(Sender: TObject);
var
  Num: Integer;
begin
  if not TryStrToInt(InputBox('Cancelar Pedido', 'Número do pedido:', '0'), Num) then Exit;

  if Num <= 0 then
  begin
    ShowMessage('Informe um número de pedido válido');
    exit;
  end;

  try
    FController.CancelarPedido(Num);
    ShowMessage('Pedido cancelado com sucesso!');
    LimparPedido;
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TfrmPedidoView.LimparPedido;
begin
  edtCodCliente.Clear;
  edtNomeCliente.Clear;
  sgItens.RowCount := 1;
  edtTotal.Text := CurrToStrF(0, ffCurrency, 2);

  FController.NovoPedido;

  LimparCamposProduto; // Reseta edição

  edtCodCliente.SetFocus;
end;

procedure TfrmPedidoView.AtualizarBotoes;
var
  ClienteEmBranco: Boolean;
begin
  ClienteEmBranco := Trim(edtCodCliente.Text) = '';
  btnCarregar.Visible := ClienteEmBranco;
  btnCancelar.Visible := ClienteEmBranco;
end;

end.
