SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnCustomGetUsersByLegalEntityId](@IndigoClientId bigint, @LegalEntityId bigint)
RETURNS TABLE
AS
RETURN
SELECT
	UserId
FROM
	(
	SELECT
		UserId, 
		G.Identifier AS [Group],
		CASE 
			WHEN G.LegalEntity = 1 THEN G.GroupId
			WHEN G2.LegalEntity = 1 THEN G2.GroupId
			WHEN G3.LegalEntity = 1 THEN G3.GroupId
			WHEN G4.LegalEntity = 1 THEN G4.GroupId
			WHEN G5.LegalEntity = 1 THEN G5.GroupId
			WHEN G6.LegalEntity = 1 THEN G6.GroupId
		END AS LegalEntityId
	FROM
		Administration..TUser U
		JOIN Administration..TGroup G ON G.GroupId = U.GroupId
		LEFT JOIN Administration..TGroup G2 ON G2.GroupId = G.ParentId
		LEFT JOIN Administration..TGroup G3 ON G3.GroupId = G2.ParentId
		LEFT JOIN Administration..TGroup G4 ON G4.GroupId = G3.ParentId
		LEFT JOIN Administration..TGroup G5 ON G5.GroupId = G4.ParentId
		LEFT JOIN Administration..TGroup G6 ON G6.GroupId = G5.ParentId
	WHERE
		U.IndigoClientId = @IndigoClientId) AS Users
WHERE
	Users.LegalEntityId = @LegalEntityId
GO
