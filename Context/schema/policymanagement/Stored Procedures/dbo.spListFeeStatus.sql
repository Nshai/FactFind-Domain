SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spListFeeStatus]
	@FeeId INT,
	@TenantId INT
AS
DECLARE @AutoMatching int = 999999999
	SELECT
		fs.FeeStatusId AS 'Id',
		fs.Status AS 'StatusName',
		fs.StatusDate,
		CASE WHEN fs.UpdatedUserId = @AutoMatching THEN 'System'
		ELSE COALESCE(crmContact.FirstName + ' ' + crmContact.LastName, refut.Identifier) END AS 'ChangedByUser'
	FROM TFeeStatus fs
	INNER JOIN TFee f ON f.FeeId = fs.FeeId
	LEFT JOIN administration..TUser u ON u.UserId = fs.UpdatedUserId
	LEFT JOIN administration..TRefUserType refut ON refut.RefUserTypeId = u.RefUserTypeId
	LEFT JOIN crm..TCRMContact crmContact ON crmContact.CRMContactId = u.CRMContactId
	WHERE 
		fs.FeeId = @FeeId
	ORDER BY fs.StatusDate ASC
