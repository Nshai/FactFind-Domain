SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [dbo].[SpCustomListAvailableLegalEntitiesByIndigoClientId]
	(
		@IndigoClientId bigint
	)

AS
	SELECT
	GroupId, 
	Identifier
	FROM TGroup
	WHERE IndigoClientId = @IndigoClientId AND LegalEntity = 1
	ORDER BY Identifier ASC
GO
