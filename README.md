# Delphi Sales Order System – WK Technical Challenge

Este projeto foi desenvolvido como parte do **teste técnico da WK Technology**.

Trata-se de um sistema simples de **Pedidos de Venda**, implementado em **Delphi (VCL)**, utilizando **MySQL** como banco de dados e **FireDAC** para acesso aos dados, seguindo princípios de **POO, MVC e Clean Code**, conforme solicitado no desafio.

---

## 📋 Funcionalidades

- Cadastro de **Pedido de Venda**
- Seleção de **Cliente** (dados pré-cadastrados)
- Inclusão de **Produtos** no pedido informando:
  - Código do produto
  - Quantidade
  - Valor unitário
- Visualização dos itens em **grid**
- Edição de item via **ENTER**
- Remoção de item via **DEL**, com confirmação
- Permite **produtos repetidos**
- Cálculo automático do **valor total do pedido**
- Gravação do pedido em:
  - Tabela de dados gerais do pedido
  - Tabela de itens do pedido
- Carregar pedido existente
- Cancelar pedido existente

---

## 🗂️ Estrutura do Projeto

<img width="771" height="427" alt="image" src="https://github.com/user-attachments/assets/f7778297-e957-4e7c-855c-636efb2d5655" />



---

## 🛠️ Tecnologias Utilizadas

- **Delphi (VCL)**
- **FireDAC**
- **MySQL**
- SQL nativo (INSERT, SELECT, DELETE)
- Arquivo `.ini` para configuração dinâmica de conexão

---

## ⚙️ Configuração do Banco de Dados

1. Criar um banco MySQL local
2. Executar o script:

database/wk_pedidos.sql

makefile
Copiar código

3. Ajustar o arquivo `config.ini` conforme o ambiente local:

```ini
[DB]
Database=wk_pedidos
Username=root
Password=123
Server=localhost
Port=3306
Lib=libmysql.dll
▶️ Execução
Abrir o projeto no Delphi

Compilar o projeto

Garantir que config.ini e libmysql.dll estejam no mesmo diretório do executável

📝 Observações
Os cadastros de Clientes e Produtos já estão populados no banco para fins de teste

O projeto prioriza o uso de SQL explícito, conforme solicitado no desafio

Não são utilizados componentes de terceiros

👤 Autor
Carlos Alexandre Campos Pereira
Teste técnico – WK Technology
