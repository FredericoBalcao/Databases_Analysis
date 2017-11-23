Use AWSAD;
Go

IF OBJECT_ID (N'FactVendas') IS NOT NULL
	DROP TABLE FactVendas;

Go
Create Table FactVendas
(
	VendasID			int							NOT NULL			IDENTITY(0,1),
	VendaID				int							NOT NULL,
	ClienteID			int							NOT NULL,
	ProdutoID			int							NOT NULL,
	Data				datetime					NOT NULL,
	DataEnviada			datetime					NULL,
	DataEncomendada		datetime					NOT NULL,
	Quantidade			int							NOT NULL,
	PrecoTotalEncomenda	money						NOT NULL,
	TempoEntrega		int							NOT NULL,
	CONSTRAINT			PK_Vendas_VendasID			Primary Key (VendasID)
);

IF OBJECT_ID (N'FactProducao') IS NOT NULL
	DROP TABLE FactProducao;

Go
Create Table FactProducao
(
	ProducaoID				int							NOT NULL		IDENTITY,
	ProdutoID				int							NULL,
	RejeicaoID				int							NULL,
	Data					datetime					NULL,
	QuantidadePedido		int							NULL,
	QuantidadeEmStock		int							NULL,
	QuantidadeRejeitada		int							NULL,
	CONSTRAINT				PK_ProducaoID				Primary Key (ProducaoID),
);


IF OBJECT_ID (N'FactCompras') IS NOT NULL
	DROP TABLE FactCompras;

Go
Create Table FactCompras
(
	ComprasID				int						NOT NULL		IDENTITY,
	CompraID				int						NOT NULL,
	FornecedorID			int						NOT NULL,
	ProdutoID				int						NOT NULL,
	Data					datetime				NOT NULL,
	Preco					money					NOT NULL,
	CustoAquisicao			money					NOT NULL,
	Quantidade				int						NULL,
	QuantidadeRecebida		int						NULL,
	QuantidadeRejeitada		int						NULL,
	QuantidadeEmStock		int						NULL,
	CONSTRAINT				PK_Compras_ComprasID		Primary Key(ComprasID)
);

IF OBJECT_ID (N'DimFornecedor') IS NOT NULL
	DROP TABLE DimFornecedor;

Go
Create Table DimFornecedor
(
	FornecedorID	int					NOT NULL,					
	Nome			nvarchar(50)		NULL,						
	Endereco		nvarchar(60)		NULL,						
	Cidade			nvarchar(50)		NULL,						
	Estado			nvarchar(50)		NULL,						
	Pais			nvarchar(60)		NULL,						
	CONSTRAINT		PK_FornecedorID		Primary Key (FornecedorID)
);  

IF OBJECT_ID (N'DimData') IS NOT NULL
	DROP TABLE DimData;

Go
Create Table DimData
(
	DataID			int				NOT NULL	IDENTITY,
	Data			datetime		NOT NULL,
	Dia				int				NOT NULL,
	Mes				int				NOT NULL,
	Ano				int				NOT NULL,
	NomeDiaSemana	nvarchar(50)	NOT NULL,
	NomeMes			nvarchar(50)	NOT NULL,
	Trimestre		smallint		NOT NULL,
	Semestre		smallint		NOT NULL,
	CONSTRAINT		PK_Data			Primary Key (Data)
);

IF OBJECT_ID (N'DimProduto') IS NOT NULL
	DROP TABLE DimProduto;

Go
Create Table DimProduto 
(
	ProdutoID				int				NOT NULL,			
	Nome					nvarchar(50)	NOT NULL,			
	CategoriaProduto		nvarchar(50)	NULL,				
	SubCategoriaProduto		nvarchar(50)	NULL,				
	CustoPadrao				money			NULL,				
	Preco					money			NULL,				
	LinhaProducao			nvarchar(100)	NULL,				--linha de produção (dos produtos)
	CONSTRAINT				PK_ProdutoID	Primary Key (ProdutoID)
);

IF OBJECT_ID (N'DimRejeicao') IS NOT NULL
	DROP TABLE DimRejeicao;

Go
Create Table DimRejeicao
(
	RejeicaoID		int						NOT NULL,				
	Nome			nvarchar(50)			NOT NULL,				
	CONSTRAINT		PK_RejeicaoID			Primary Key (RejeicaoID)
);

IF OBJECT_ID (N'DimCliente') IS NOT NULL
	DROP TABLE DimCliente;

Go
Create Table DimCliente
(
	ClienteID		int						Not null,				
	Nome			nvarchar(200)			Not null,				--primeiro e ultimo nome do cliente
	Morada			nvarchar(100)			null,					
	TipoEndereco	nvarchar(100)			null,					--tipo de endereço do cliente (casa ou empresa)
	Cidade			nvarchar(100)			null,					
	CodigoPostal	nvarchar(20)			null,					
	Regiao			nvarchar(100)			null,					
	Pais			nvarchar(100)			null,					
	CONSTRAINT		PK_ClienteID			Primary Key (ClienteID)
);

ALTER TABLE FactVendas		ADD CONSTRAINT FK_Vendas_ProdutoID			Foreign Key (ProdutoID)		REFERENCES DimProduto (ProdutoID);
ALTER TABLE FactVendas		ADD CONSTRAINT FK_Vendas_ClienteID			Foreign Key (ClienteID)		REFERENCES DimCliente (ClienteID);
ALTER TABLE FactVendas		ADD CONSTRAINT FK_Vendas_Data				Foreign Key (Data)			REFERENCES DimData (Data);
ALTER TABLE FactProducao	ADD CONSTRAINT FK_Producao_ProdutoID		Foreign Key (ProdutoID)		REFERENCES DimProduto (ProdutoID);
ALTER TABLE FactProducao	ADD CONSTRAINT FK_Producao_Data				Foreign Key (Data)			REFERENCES DimData (Data);
ALTER TABLE FactProducao	ADD CONSTRAINT FK_Producao_RejeicaoID		Foreign Key (RejeicaoID)	REFERENCES DimRejeicao (RejeicaoID);
ALTER TABLE FactCompras		ADD CONSTRAINT FK_Compras_FornecedorID		Foreign Key (FornecedorID)	REFERENCES DimFornecedor(FornecedorID);
ALTER TABLE FactCompras		ADD CONSTRAINT FK_Compras_ProdutoID			Foreign Key (ProdutoID)		REFERENCES DimProduto (ProdutoID);
ALTER TABLE FactCompras		ADD CONSTRAINT FK_Compras_Data				Foreign Key (Data)			REFERENCES DimData (Data);