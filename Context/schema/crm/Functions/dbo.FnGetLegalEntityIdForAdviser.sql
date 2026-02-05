SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnGetLegalEntityIdForAdviser](@AdviserId as BIGINT)
RETURNS BIGINT
AS
BEGIN
	DECLARE @GroupId bigint, @ParentId bigint, @LegalEntity bit
	
	-- Get Immediate Group Information for the specified user
	SELECT 
		@GroupId = G.GroupId,
		@LegalEntity = LegalEntity
	FROM 
		Administration..TGroup G
		JOIN Administration..TUser U ON U.GroupId = G.GroupId 
		JOIN CRM..TPractitioner P ON P.CRMContactId = U.CRMContactId
	WHERE 
		P.PractitionerId = @AdviserId
	
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
				@GroupId = GroupId,
				@LegalEntity = LegalEntity
			FROM 
				Administration..TGroup 
			WHERE 
				GroupId = @ParentId

			IF @LegalEntity = 1
			BEGIN				
				RETURN @GroupId
			END

			SELECT @ParentId = ISNULL(ParentId, 0) FROM Administration..TGroup WHERE GroupId = @ParentId
		END
	END

	RETURN @GroupId
END
GO
