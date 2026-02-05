SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spGetLastCreatedClientTypeByUserIdQuery]
	@userId INT,
	@tenantId INT
AS
BEGIN

	SELECT TOP(1)
	c.CRMContactType AS ClientType
	FROM TCRMContact c
	LEFT JOIN TPerson p ON c.PersonId = p.PersonId
	LEFT JOIN TTrust t ON c.TrustId = t.TrustId
	LEFT JOIN TCorporate corp ON c.CorporateId = corp.CorporateId
	WHERE c.IndClientId = @tenantId AND
		((p.PersonId IS NOT NULL AND p.CreatedByUserId = @userId) OR
		(t.TrustId IS NOT NULL AND t.CreatedByUserId = @userId) OR
		(corp.CorporateId IS NOT NULL AND corp.CreatedByUserId = @userId)) AND
		c.RefCRMContactStatusId = 1 AND
		ISNULL(c.InternalContactFG, 0) = 0
	ORDER BY c.CRMContactId DESC

END
GO
