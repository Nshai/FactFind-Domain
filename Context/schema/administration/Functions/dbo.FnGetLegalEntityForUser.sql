SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [dbo].[FnGetLegalEntityForUser](@UserId as BIGINT)
--
-- Returns Legal Entity Information as a table
--
RETURNS @Group TABLE (
	UserId bigint,
	Identifier varchar(64),
	ImageLocation varchar(500),
	AcknowledgementsLocation varchar(500),
	GroupId bigint
)
AS
BEGIN
	DECLARE @GroupId bigint, @ParentId bigint
	DECLARE @Identifier varchar(64), @Image varchar(500), @Acknowledgements varchar(500), @LegalEntity bit
	
	-- Get Immediate Group Information for the specified user
	SELECT 
		@GroupId = G.GroupId,
		@Identifier = G.Identifier,
		@Image = ISNULL(GroupImageLocation, ''), 
		@Acknowledgements = ISNULL(AcknowledgementsLocation, ''),
		@LegalEntity = LegalEntity
	FROM 
		Administration..TGroup G
		JOIN Administration..TUser U ON U.GroupId = G.GroupId 
	WHERE 
		U.UserId = @UserId
	
	IF @LegalEntity = 1
	BEGIN
		INSERT @Group SELECT @UserId, @Identifier, @Image, @Acknowledgements, @GroupId
		RETURN
	END
	ELSE
	BEGIN
		-- Find the parent
		SELECT @ParentId = ISNULL(ParentId, 0) FROM Administration..TGroup WHERE GroupId = @GroupId

		WHILE @ParentId > 0 
		BEGIN	
			-- Get Group Information for the parent group
			SELECT 
				@Image = ISNULL(GroupImageLocation, ''), 
				@Acknowledgements = ISNULL(AcknowledgementsLocation, ''),
				@Identifier = Identifier,
				@LegalEntity = LegalEntity
			FROM 
				Administration..TGroup 
			WHERE 
				GroupId = @ParentId

			IF @LegalEntity = 1
			BEGIN
				INSERT @Group SELECT @UserId, @Identifier, @Image, @Acknowledgements, @ParentId
				RETURN
			END
			ELSE
				SELECT @ParentId = ISNULL(ParentId, 0) FROM Administration..TGroup WHERE GroupId = @ParentId
		END
	END

	INSERT @Group SELECT @UserId, '', '', '', ''
	RETURN
END
GO
