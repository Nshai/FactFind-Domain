SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spGetPolicyBusinessExtByIdQuery]
	@PolicyBusinessId INT,
	@TenantId INT
AS

SELECT
	pbe.IsVisibleToClient
FROM 
	TPolicyBusinessExt pbe
INNER JOIN 
	TPolicyBusiness pb ON pb.PolicyBusinessId = pbe.PolicyBusinessId AND pb.IndigoClientId = @TenantId 
WHERE 
	pbe.PolicyBusinessId = @PolicyBusinessId

GO