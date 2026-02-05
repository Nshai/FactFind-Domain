SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [dbo].[FundCSV](@PolicyBusinessId BIGINT)

RETURNS VARCHAR(1000) AS  
BEGIN 

DECLARE @Fund varchar(1000)
SET @Fund = ''

-- Get a comma delimited lisit of plan puposes for the PolicyBusinessId supplied
SELECT @Fund = @Fund + f.[Name] + ', '
FROM PolicyManagement..TPolicyBusinessFund pbf
INNER JOIN PolicyManagement..TPolicyBusiness pb ON pbf.PolicyBusinessId = pb.PolicyBusinessId
INNER JOIN PolicyManagement..TFund f ON pbf.FundId = f.FundId
WHERE pb.PolicyBusinessId = @PolicyBusinessId

-- Remove any trailing commas
DECLARE @strLen BIGINT
SET @strLen = LEN(@Fund)

IF @strLen > 0 BEGIN
	SET @Fund = LEFT(@Fund, @strLen - 1)
END

RETURN @Fund

END





GO
