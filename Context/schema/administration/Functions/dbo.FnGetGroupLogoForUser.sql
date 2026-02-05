SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnGetGroupLogoForUser](@UserId as BIGINT)
RETURNS VARCHAR(1000)
AS
BEGIN
	DECLARE @GroupId bigint, @ParentId bigint, @Count tinyint
	DECLARE @Identifier varchar(64), @Image varchar(500), @Acknowledgements varchar(500), @LegalEntity bit
	
	-- Get Immediate Group Information for the specified user
	SELECT 
		@Image = ISNULL(G.DocumentFileReference, ''),
		@ParentId = G.ParentId
	FROM 
		Administration..TGroup G WITH(NOLOCK)
		JOIN Administration..TUser U WITH(NOLOCK) ON U.GroupId = G.GroupId 
	WHERE 
		U.UserId = @UserId
	
	-- Count is here just in case (we don't want an endless loop - shouldn't happen but...)
	SET @Count = 0
	WHILE LEN(@Image) = 0 AND @ParentId IS NOT NULL AND @Count < 10
	BEGIN
		-- Get Group Information for the parent group
		SELECT 
			@Image = ISNULL(DocumentFileReference, ''),
			@ParentId = ParentId
		FROM 
			Administration..TGroup WITH(NOLOCK)
		WHERE 
			GroupId = @ParentId

		SET @Count = @Count + 1
	END

	IF LEN(@Image) = 0
		SET @Image = NULL

	RETURN @Image
END
GO
