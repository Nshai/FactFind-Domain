SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnGetLegalEntityGroupIdForGroup](@GroupId as BIGINT)

RETURNS bigint

AS
BEGIN

	DECLARE @ParentId bigint
	DECLARE @LegalEntity bit = 0, @Count tinyint = 0

	WHILE @LegalEntity = 0 AND @Count < 10
		BEGIN
			
			IF @GroupId IS NULL
				return (0)

			SELECT 
				@ParentId = ParentId,
				@LegalEntity = LegalEntity
			FROM 
				Administration..TGroup 
			WHERE 
				GroupId = @GroupId

			IF @LegalEntity = 1
				RETURN @GroupId
			ELSE
				SELECT @GroupId = GroupId FROM Administration..TGroup WHERE GroupId = @ParentId

			SET @Count = @Count + 1
		END

	RETURN (0)
END
GO
