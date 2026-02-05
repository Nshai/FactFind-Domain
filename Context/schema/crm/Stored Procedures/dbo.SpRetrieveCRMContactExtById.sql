SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveCRMContactExtById]
	@CRMContactExtId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.CRMContactExtId AS [CRMContactExt!1!CRMContactExtId], 
	T1.CRMContactId AS [CRMContactExt!1!CRMContactId], 
	ISNULL(T1.CreditedGroupId, '') AS [CRMContactExt!1!CreditedGroupId], 
	T1.ConcurrencyId AS [CRMContactExt!1!ConcurrencyId]
	FROM TCRMContactExt T1
	
	WHERE T1.CRMContactExtId = @CRMContactExtId
	ORDER BY [CRMContactExt!1!CRMContactExtId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
