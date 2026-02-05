SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpCustomMoveUserToDifferentGroupForLAndG]

@UserName VARCHAR(64),
@UserCrmContactId BIGINT,
@GroupNameForChange VARCHAR(64),
@IndigoClientId BIGINT

AS

BEGIN

-- Get the groupId from group Name first.
DECLARE @GroupId BIGINT
DECLARE @UserId BIGINT

SELECT @GroupId = GroupId from TGroup G
WHERE G.Identifier LIKE @GroupNameForChange
AND G.IndigoClientId = @IndigoClientId 

-- If the new group has been found
IF @GroupId > 0

BEGIN

	-- Get the User Id
	SELECT @UserId=UserId FROM TUser U
	WHERE U.CrmContactId = @UserCrmContactId
	AND U.Identifier LIKE @UserName
	AND U.IndigoClientId = @IndigoClientId

	-- If the User Id has been found
	IF @UserId > 0
	BEGIN
			DECLARE @tx int  
					
			IF @tx = 0 BEGIN TRANSACTION TX   
			SELECT @tx = @@TRANCOUNT 

			-- Update the Audit First
			EXEC SpNAuditUser '999999', @UserId, 'U'

			-- Update the User's Group now.
			UPDATE TUser
			SET GroupId = @GroupId
			WHERE UserId = @UserId

			IF @tx != 0 COMMIT TRANSACTION TX  
			 
			END
		    
		GOTO exit_success

		exit_on_error:    
		IF @tx != 0 ROLLBACK TRANSACTION TX    

		exit_success:
	END

END

--EXEC SpCustomMoveUserToDifferentGroupForLAndG 'CCoo10155', 4670709,  'Organisation', 10155


