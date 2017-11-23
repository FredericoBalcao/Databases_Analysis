--Instituto Politécnico de Portalegre
--Escola Superior de Tecnologia e Gestão de Portalegre
--Engenharia Informática, 2ºAno, 2ºSem
--Trabalho Prático - Base de Dados II
--Nome: Frederico Balcão
--Numero: 15307
--------------------------------------------------------------------------------------------------------------
Use AWSAD
--SELECT's

--Select para a Dimensão Fornecedor
SELECT 
	V.[BusinessEntityID] AS FornecedorID,				
	V.[Name]			 AS Nome,						
	A.[AddressLine1]	 AS Endereco,					
	A.[City]			 AS Cidade,						
	SP.[Name]			 AS Estado,						
	CR.[Name]			 AS Pais						
FROM 
	[AdventureWorks2014].[Purchasing].[Vendor] V,
	[AdventureWorks2014].[Person].[BusinessEntity] BE,
	[AdventureWorks2014].[Person].[BusinessEntityAddress] BEA,
	[AdventureWorks2014].[Person].[Address] A,
	[AdventureWorks2014].[Person].[StateProvince] SP,
	[AdventureWorks2014].[Person].[CountryRegion] CR
WHERE
	V.BusinessEntityID=BE.BusinessEntityID		AND
	BE.BusinessEntityID=BEA.BusinessEntityID	AND
	BEA.AddressID=A.AddressID					AND
	A.StateProvinceID=SP.StateProvinceID		AND
	SP.CountryRegionCode=CR.CountryRegionCode

--------------------------------------------------------------------------------------------------------------
--Select da Dimensão Produto

Select Distinct
	P.[ProductID]				AS ProdutoID,				
	P.[Name]					AS Nome,					
	PC.[Name]					AS CategoriaProduto,		
	PSC.[Name]					AS SubCategoriaProduto,		
	P.[StandardCost]			AS CustoPadrao,				
	P.[ListPrice]				AS Preco,					
	P.[ProductLine]				AS LinhaProducao			
From
	[AdventureWorks2014].[Production].[Product] P LEFT JOIN [AdventureWorks2014].[Production].[ProductSubcategory] PSC
	ON P.ProductSubcategoryID = PSC.ProductSubcategoryID LEFT JOIN [AdventureWorks2014].[Production].[ProductCategory] PC 
	ON PSC.ProductCategoryID = PC.ProductCategoryID

--------------------------------------------------------------------------------------------------------------
--Select para Dimensão Rejeição
Select 
	SR.[ScrapReasonID] AS RejeicaoID,							
	SR.[Name] AS Nome										
From
	[AdventureWorks2014].[Production].[ScrapReason] SR

--------------------------------------------------------------------------------------------------------------
--Select para Dimensão Cliente

Select 
	P.BusinessEntityID			AS ClienteID,					
	P.FirstName+' '+P.LastName	AS Nome,					--juntei o primeiro e ultimo nome 
	A.AddressLine1				AS Morada,						
	AT.Name						AS TipoEndereco,			--casa ou empresa			
	A.City						AS Cidade,						
	A.PostalCode				AS CodigoPostal,				
	SP.Name						AS Regiao,						
	CR.Name						AS Pais	
From
	[AdventureWorks2014].[Person].[Person] P LEFT JOIN [AdventureWorks2014].[Person].[BusinessEntityAddress] BEA ON
	P.[BusinessEntityID] = BEA.BusinessEntityID LEFT JOIN  [AdventureWorks2014].[Person].[Address] A	ON
	BEA.AddressID = A.AddressID LEFT JOIN [AdventureWorks2014].[Person].[StateProvince] SP ON SP.StateProvinceID = A.StateProvinceID 
	LEFT JOIN [AdventureWorks2014].[Person].[CountryRegion] CR ON CR.CountryRegionCode = SP.CountryRegionCode LEFT JOIN
	[AdventureWorks2014].[Person].[AddressType] AS AT ON AT.AddressTypeID = BEA.AddressTypeID
	Where AT.Name ='home' or AT.Name IS NULL
	
------------------------------------------------------------------------------------------------------------------
--Select's para Dimensão Data com a junção das tabelas de purchasing, sales e production pelo UNION
Select * From (
Select Distinct 
	DueDate			AS Data,
	DAY(DueDate)	AS Dia,
	MONTH(DueDate)	AS Mes,
	YEAR(DueDate)	AS Ano,
		DATEPART(QUARTER, DueDate) AS Trimestre,
	CASE
		WHEN DATEPART(QUARTER, DueDate) > 2 THEN 2
		ELSE 1
	END AS Semestre,
	DATENAME(WEEKDAY, DueDate) AS NomeDiaSemana,
	DATENAME(MONTH, DueDate) AS NomeMes 
From	
	AdventureWorks2014.Purchasing.PurchaseOrderDetail AS POD
UNION
Select Distinct 
	DueDate			AS Data,
	DAY(DueDate)	AS Dia,
	MONTH(DueDate)	AS Mes,
	YEAR(DueDate)	AS Ano,
		DATEPART(QUARTER, DueDate) AS Trimestre,
	CASE
		WHEN DATEPART(QUARTER, DueDate) > 2 THEN 2
		ELSE 1
	END AS Semestre,
	DATENAME(WEEKDAY, DueDate) AS NomeDiaSemana,
	DATENAME(MONTH, DueDate) AS NomeMes 
From
	AdventureWorks2014.Sales.SalesOrderHeader AS SOH
UNION
Select Distinct 
	DueDate		AS Data,
	DAY(DueDate)	AS Dia,
	MONTH(DueDate)	AS Mes,
	YEAR(DueDate)	AS Ano,
		DATEPART(QUARTER, DueDate) AS Trimestre,
	CASE
		WHEN DATEPART(QUARTER, DueDate) > 2 THEN 2
		ELSE 1
	END AS Semestre,
	DATENAME(WEEKDAY, DueDate) AS NomeDiaSemana,
	DATENAME(MONTH, DueDate) AS NomeMes 
From	
	AdventureWorks2014.Production.WorkOrder AS WO
UNION
Select Distinct 
	ShipDate		AS Data,
	DAY(ShipDate)	AS Dia,
	MONTH(ShipDate)	AS Mes,
	YEAR(ShipDate)	AS Ano,
		DATEPART(QUARTER, ShipDate) AS Trimestre,
	CASE
		WHEN DATEPART(QUARTER, ShipDate) > 2 THEN 2
		ELSE 1
	END AS Semestre,
	DATENAME(WEEKDAY, ShipDate) AS NomeDiaSemana,
	DATENAME(MONTH, ShipDate) AS NomeMes 
From	
	AdventureWorks2014.Sales.SalesOrderHeader AS SOH
UNION
Select Distinct 
	OrderDate		AS Data,
	DAY(OrderDate)	AS Dia,
	MONTH(OrderDate)	AS Mes,
	YEAR(OrderDate)	AS Ano,
		DATEPART(QUARTER, OrderDate) AS Trimestre,
	CASE
		WHEN DATEPART(QUARTER, OrderDate) > 2 THEN 2
		ELSE 1
	END AS Semestre,
	DATENAME(WEEKDAY, OrderDate) AS NomeDiaSemana,
	DATENAME(MONTH, OrderDate) AS NomeMes 
From	
	AdventureWorks2014.Sales.SalesOrderHeader) AS SOH

--------------------------------------------------------------------------------------------------------------
--Select para o Facto Vendas
Select --pudia ser usado aqui um Distinct
	SOH.[SalesOrderID]													AS VendaID,			
	P.[BusinessEntityID]												AS ClienteID,		
	SOD.[ProductID]														AS ProdutoID,		
	SOH.[DueDate]														AS Data,
	SOH.[ShipDate]														AS DataEnviada,	
	SOH.[OrderDate]														AS DataEncomendada,
	SOD.[OrderQty]														AS Quantidade,
	SOH.[TotalDue]														AS PrecoTotalEncomenda,
	DATEDIFF(DAY,SOH.OrderDate, SOH.DueDate)							AS TempoEntrega --em dias
From
	[AdventureWorks2014].[Sales].[SalesOrderDetail] SOD JOIN [AdventureWorks2014].[Sales].[SalesOrderHeader] SOH ON
	SOD.SalesOrderID = SOH.SalesOrderID JOIN [AdventureWorks2014].[Sales].[Customer] C ON C.CustomerID = SOH.CustomerID  
	JOIN [AdventureWorks2014].[Person].[Person] P ON C.PersonID = P.BusinessEntityID 

-------------------------------------------------------------------------------------------------------------
--Select para o Facto Compras
Select Distinct
	POH.[PurchaseOrderID]	AS CompraID,			
	POH.[VendorID]			AS FornecedorID,			
	POD.[ProductID]			AS ProdutoID,				
	POD.[DueDate]			AS Data,							
	POD.[UnitPrice]			AS Preco,
	POD.[LineTotal]			AS CustoAquisicao,					
	POD.[OrderQty]			AS Quantidade,				
	POD.[ReceivedQty]		AS QuantidadeRecebida,		
	POD.[RejectedQty]		AS QuantidadeRejeitada,		
	POD.[StockedQty]		AS QuantidadeEmStock				
From
	[AdventureWorks2014].[Purchasing].[PurchaseOrderHeader] POH,
	[AdventureWorks2014].[Purchasing].[PurchaseOrderDetail] POD
Where	
	POD.PurchaseOrderID = POH.PurchaseOrderID 

--------------------------------------------------------------------------------------------------------------
--Select para o Facto Produção
Select  
	P.ProductID				AS ProdutoID,
	WO.[EndDate]			AS DataProducao,
	WO.[OrderQty]			AS QuantidadePedido,				
	WO.[StockedQty]			AS QuantidadeEmStock,		
	WO.[ScrappedQty]		AS QuantidadeRejeitada,
	WO.[ScrapReasonID]		AS RejeicaoID
From
	[AdventureWorks2014].[Production].[Product] P JOIN [AdventureWorks2014].[Production].[WorkOrder] WO 
	ON P.ProductID = WO.ProductID