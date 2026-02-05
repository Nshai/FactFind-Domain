SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomGetSuperUserRights]
	@UserId bigint,
	@Entity varchar(128),
	@RightMask int OUTPUT ,
	@AdvancedMask int OUTPUT 
AS
BEGIN
	-- Declarations
	DECLARE @SuperUser bit
	-- Defaults
	SELECT @RightMask = 1, @AdvancedMask = 0
	-- Check for superuser
	IF EXISTS (SELECT 1 FROM TUser WHERE SuperUser = 1 AND UserId = ABS(@UserId))
		SELECT @RightMask = 15, @AdvancedMask = 240
	ELSE
		SELECT 
			@RightMask = RightMask,	
			@AdvancedMask = AdvancedMask
		FROM
			VwPolicyRights
		WHERE
			UserId = ABS(@UserId)
			AND Entity = @Entity
END
GO
