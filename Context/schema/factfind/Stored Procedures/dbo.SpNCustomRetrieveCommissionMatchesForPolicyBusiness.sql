SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveCommissionMatchesForPolicyBusiness]
	@IndigoClientId int,@PolicyBusinessId bigint
AS
BEGIN
	SELECT ProvBreakId
	FROM Commissions..TProvBreak A
	WHERE PolicyId=@PolicyBusinessId
	AND IndClientId=@IndigoClientId
	AND AnalyseFG=1
END
GO
