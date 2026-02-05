SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveSellingAdviserDetails]
	@TenantId bigint,
	@ClientId bigint
AS
SELECT
	U.CRMContactId,
	U.UserId	
FROM	
	CRM..TCRMContact C
	JOIN Administration..TUser U ON U.CRMContactId = C.CurrentAdviserCRMId
WHERE
	C.IndClientId = @TenantId
	AND C.CRMContactId = @ClientId	
GO
