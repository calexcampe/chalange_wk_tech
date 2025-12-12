program Project1;

uses
  Vcl.Forms,
  uPedidoView in 'src\views\uPedidoView.pas' {frmPedidoView},
  uClienteModel in 'src\models\uClienteModel.pas',
  uProdutoModel in 'src\models\uProdutoModel.pas',
  uPedidoModel in 'src\models\uPedidoModel.pas',
  uPedidoItemModel in 'src\models\uPedidoItemModel.pas',
  uConexao in 'src\dao\uConexao.pas',
  uClienteDAO in 'src\dao\uClienteDAO.pas',
  uProdutoDAO in 'src\dao\uProdutoDAO.pas',
  uPedidoDAO in 'src\dao\uPedidoDAO.pas',
  uPedidoController in 'src\controller\uPedidoController.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPedidoView, frmPedidoView);
  Application.Run;
end.
