SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.nio_PermissionUserSearchColumnList
AS
BEGIN
SELECT
	0  AS UserId,
	0  AS CRMContactId,
	'' AS FirstName,	
	'' AS LastName,	
    '' AS GroupingName,
    '' AS GroupName	
END
GO
