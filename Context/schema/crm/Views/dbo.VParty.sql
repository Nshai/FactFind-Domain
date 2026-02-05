SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE View [dbo].[VParty]
AS

SELECT
	C.*,
	U.UserId
FROM
	CRM..TCRMContact C
	LEFT JOIN Administration..TUser U ON U.CRMContactId = C.CRMContactId
	
GO
