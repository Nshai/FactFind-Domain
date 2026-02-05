USE [factfind]
GO

/****** Object:  UserDefinedFunction [dbo].[FnCustomGetRecommendationMortgageEquityAddress]    Script Date: 12/02/2019 16:47:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FnCustomGetRecommendationMortgageEquityAddress] 
(
	@SelectedAddress VARCHAR(255)	
)
RETURNS VARCHAR(255)
AS
BEGIN
	DECLARE @addressId INT
	DECLARE @returnValue NVARCHAR(255) = null

	IF (@SelectedAddress IS NULL) RETURN @returnValue;

	--Selected address property stored as int if it is Equity Release or old created Mortgage recommendation
	--for new created Mortgage recommendation it is stored as composite key prefix_Id 

	IF ISNUMERIC(@SelectedAddress) = 1
		BEGIN
			SET @addressId = CAST(@SelectedAddress as INT)
			SELECT @returnValue = AddressLine1 FROM CRM..TAddress a WITH(NOLOCK) 
			JOIN CRM..TAddressStore ast on a.AddressStoreId = ast.AddressStoreId
			WHERE a.AddressId = @addressId
		END	

	RETURN @returnValue

END
GO


