SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveLegalEntityForUser]
	@UserId bigint
AS
BEGIN	
	-- Get Immediate Group Information for the specified user
	SELECT 
		CASE
			WHEN G1.LegalEntity = 1 THEN G1.GroupId
			WHEN G2.LegalEntity = 1 THEN G2.GroupId
			WHEN G3.LegalEntity = 1 THEN G3.GroupId
			WHEN G4.LegalEntity = 1 THEN G4.GroupId
			WHEN G5.LegalEntity = 1 THEN G5.GroupId
		END AS GroupId,
		CASE
			WHEN G1.LegalEntity = 1 THEN G1.Identifier
			WHEN G2.LegalEntity = 1 THEN G2.Identifier
			WHEN G3.LegalEntity = 1 THEN G3.Identifier
			WHEN G4.LegalEntity = 1 THEN G4.Identifier
			WHEN G5.LegalEntity = 1 THEN G5.Identifier
		END AS Identifier,
		CASE
			WHEN G1.LegalEntity = 1 THEN G1.DocumentFileReference 
			WHEN G2.LegalEntity = 1 THEN G2.DocumentFileReference 
			WHEN G3.LegalEntity = 1 THEN G3.DocumentFileReference 
			WHEN G4.LegalEntity = 1 THEN G4.DocumentFileReference
			WHEN G5.LegalEntity = 1 THEN G5.DocumentFileReference
		END AS GroupImageLocation,
		CASE
			WHEN G1.LegalEntity = 1 THEN G1.AcknowledgementsLocation
			WHEN G2.LegalEntity = 1 THEN G2.AcknowledgementsLocation
			WHEN G3.LegalEntity = 1 THEN G3.AcknowledgementsLocation
			WHEN G4.LegalEntity = 1 THEN G4.AcknowledgementsLocation
			WHEN G5.LegalEntity = 1 THEN G5.AcknowledgementsLocation
		END AS AcknowledgementsLocation,
		CASE
			WHEN G1.LegalEntity = 1 THEN G1.ApplyFactFindBranding
			WHEN G2.LegalEntity = 1 THEN G2.ApplyFactFindBranding
			WHEN G3.LegalEntity = 1 THEN G3.ApplyFactFindBranding
			WHEN G4.LegalEntity = 1 THEN G4.ApplyFactFindBranding
			WHEN G5.LegalEntity = 1 THEN G5.ApplyFactFindBranding
		END AS ApplyFactFindBranding
	FROM 
		TUser U WITH(NOLOCK)
		JOIN Administration..TGroup G1 WITH(NOLOCK) ON G1.GroupId = U.GroupId
		LEFT JOIN Administration..TGroup G2 WITH(NOLOCK) ON G2.GroupId = G1.ParentId
		LEFT JOIN Administration..TGroup G3 WITH(NOLOCK) ON G3.GroupId = G2.ParentId
		LEFT JOIN Administration..TGroup G4 WITH(NOLOCK) ON G4.GroupId = G3.ParentId
		LEFT JOIN Administration..TGroup G5 WITH(NOLOCK) ON G5.GroupId = G4.ParentId
	WHERE 
		U.UserId = @UserId
END
GO
