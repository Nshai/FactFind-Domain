SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateAction]
	@StampUser varchar (255),
	@Identifier varchar(255) , 
	@Descriptor varchar(255) , 
	@Javascript varchar(255)  = NULL, 
	@Ordinal tinyint, 
	@FactFindTypeId bigint	
AS


DECLARE @ActionId bigint, @Result int
			
	
INSERT INTO TAction
(Identifier, Descriptor, Javascript, Ordinal, FactFindTypeId, ConcurrencyId)
VALUES(@Identifier, @Descriptor, @Javascript, @Ordinal, @FactFindTypeId, 1)

SELECT @ActionId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh

Execute @Result = dbo.SpNAuditAction @StampUser, @ActionId, 'C'

IF @Result  != 0 GOTO errh

Execute dbo.SpNRetrieveActionByActionId @ActionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
