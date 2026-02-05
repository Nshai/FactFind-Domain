SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveLegalEntityForUser]
	@UserId bigint
AS
BEGIN
	SELECT 
		UserId,
		Identifier,
		AcknowledgementsLocation,
		GroupId,
		dbo.FnGetGroupLogoForUser(@UserId) AS ImageLocation
	FROM
		dbo.FnGetLegalEntityForUser(@UserId) A
	FOR XML RAW
END
GO
