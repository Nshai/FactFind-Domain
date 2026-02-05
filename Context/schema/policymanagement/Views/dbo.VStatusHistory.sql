SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VStatusHistory]

AS

SELECT
	sh.*,
	u.CRMContactId As ChangedByCRMContactId
FROM PolicyManagement.dbo.TStatusHistory sh
LEFT JOIN Administration.dbo.TUser u ON sh.ChangedByUserId = u.UserId



GO
