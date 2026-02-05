SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnGetLegalEntityForAdviser](@AdviserId as BIGINT)
--
-- Returns Legal Entity Information as a table
--
RETURNS @Group TABLE (
	UserId bigint,
	Identifier varchar(64),
	ImageLocation varchar(500),
	AcknowledgementsLocation varchar(500),
	ApplyFactFindBranding bit
)
AS
BEGIN
	DECLARE @GroupId bigint, @ParentId bigint, @UserId bigint, @ApplyBranding bit
	DECLARE @Identifier varchar(64), @Image varchar(500), @Acknowledgements varchar(500), @LegalEntity bit
	
	-- Get Immediate Group Information for the specified user
	SELECT 
		@UserId = U.UserId,
		@GroupId = G.GroupId,
		@Identifier = G.Identifier,
		@Image = ISNULL(GroupImageLocation, ''), 
		@Acknowledgements = ISNULL(AcknowledgementsLocation, ''),
		@LegalEntity = LegalEntity,
		@ApplyBranding = ApplyFactFindBranding
	FROM 
		Administration..TGroup G
		JOIN Administration..TUser U ON U.GroupId = G.GroupId 
		JOIN CRM..TPractitioner P ON P.CRMContactId = U.CRMContactId AND P.PractitionerId = @AdviserId
	
	IF @LegalEntity = 1
	BEGIN
		INSERT @Group SELECT @UserId, @Identifier, @Image, @Acknowledgements, @ApplyBranding
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
				@LegalEntity = LegalEntity,
				@ApplyBranding = ApplyFactFindBranding
			FROM 
				Administration..TGroup 
			WHERE 
				GroupId = @ParentId

			IF @LegalEntity = 1
			BEGIN
				INSERT @Group SELECT @UserId, @Identifier, @Image, @Acknowledgements, @ApplyBranding
				RETURN
			END
			ELSE
				SELECT @ParentId = ISNULL(ParentId, 0) FROM Administration..TGroup WHERE GroupId = @ParentId
		END
	END

	INSERT @Group SELECT @UserId, '', '', '', 1
	RETURN
END

GO
