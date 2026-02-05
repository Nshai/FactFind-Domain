SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spListIncomesExcludedFromAffordabilityQuery] 
	@OwnerId1 int, @OwnerId2 int = NULL
AS

SELECT
    dib.DetailedincomebreakdownId AS Id
FROM
    TDetailedincomebreakdown dib
WHERE
	dib.HasIncludeInAffordability = 0 AND (  dib.CRMContactId = @OwnerId1 OR dib.CRMContactId = @OwnerId2)

GO