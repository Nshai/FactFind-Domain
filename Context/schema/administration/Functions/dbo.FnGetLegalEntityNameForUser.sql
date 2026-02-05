SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnGetLegalEntityNameForUser](@UserId AS bigint)
RETURNS varchar(128)
AS
BEGIN
	DECLARE
		@GroupId bigint,
		@ParentId bigint,
		@Identifier varchar(128),
		@LegalEntity bit,
		@Count int
		
	SELECT
		@GroupId = G.GroupId,
		@ParentId = G.ParentId,
		@Identifier = G.Identifier,
		@LegalEntity = G.LegalEntity
	FROM
		Administration..TUser U 
		JOIN Administration..TGroup G ON G.GroupId = U.GroupId
	WHERE
		U.UserId = @UserId

	SET @Count = 0	
	WHILE @LegalEntity = 0 AND @ParentId IS NOT NULL AND @Count < 10
	BEGIN
		SELECT
			@GroupId = G.GroupId,
			@ParentId = G.ParentId,
			@Identifier = G.Identifier,
			@LegalEntity = G.LegalEntity
		FROM
			Administration..TGroup G
		WHERE
			G.GroupId = @ParentId

		SET @Count = @Count + 1
	END

	IF @LegalEntity = 0
		SET @Identifier = ''

	RETURN @Identifier
END
GO
