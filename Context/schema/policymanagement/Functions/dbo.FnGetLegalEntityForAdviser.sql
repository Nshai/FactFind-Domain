SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnGetLegalEntityForAdviser](@AdviserId as BIGINT)
--
-- Returns the Legal Entity Group Id for the adviser
--
RETURNS NUMERIC
AS
BEGIN
	DECLARE @GroupId bigint, @ParentId bigint, @UserId bigint
	DECLARE @Identifier varchar(64), @Image varchar(500), @Acknowledgements varchar(500), @LegalEntity bit
	
	-- Get Immediate Group Information for the specified user
	SELECT 
		@UserId = U.UserId,
		@GroupId = G.GroupId,
		@Identifier = G.Identifier,
		@Image = ISNULL(GroupImageLocation, ''), 
		@Acknowledgements = ISNULL(AcknowledgementsLocation, ''),
		@LegalEntity = LegalEntity
	FROM 
		Administration..TGroup G
		JOIN Administration..TUser U ON U.GroupId = G.GroupId 
		JOIN CRM..TPractitioner P ON P.CRMContactId = U.CRMContactId AND P.PractitionerId = @AdviserId
	
	IF @LegalEntity = 1
	BEGIN
		RETURN @GroupId
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
				@LegalEntity = LegalEntity,
				@GroupId=GroupId
			FROM 
				Administration..TGroup 
			WHERE 
				GroupId = @ParentId

			IF @LegalEntity = 1
			BEGIN
				RETURN @GroupId
			END
			ELSE
				SELECT @ParentId = ISNULL(ParentId, 0) FROM Administration..TGroup WHERE GroupId = @ParentId
		END
	END

	RETURN 0
END


GO
