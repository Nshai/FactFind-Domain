SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.nio_SpCustomSearchActiveAdvisersGetColumnList

AS

BEGIN

	SELECT
		0 AS CRMContactId,
		0 AS PractitionerId,
		0 AS UserPartyId,
		'' AS AdviserName, 
		'' AS GroupingName, 
		'' AS GroupName,
		'' AS UserName

END
GO
