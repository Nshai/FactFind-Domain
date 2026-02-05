SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [dbo].[SpCustomGetProductProviderById]
	(
		@ProviderId bigint, 
		@RegionCode varchar(10)
	)

AS
	SELECT 
	RefProdProviderId AS ID,
	Name
	FROM VProvider
	WHERE RefProdProviderId = @ProviderId AND 
	RetireFg = 0 AND
	IsBankAccountTransactionFeed = 0 AND
	RegionCode = @RegionCode
GO
