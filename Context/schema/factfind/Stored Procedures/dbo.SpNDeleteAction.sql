SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNDeleteAction]
	@ActionId Bigint,
	@ConcurrencyId int,
	@StampUser varchar (255)
	
AS

Declare @Result int
Execute @Result = dbo.SpNAuditAction @StampUser, @ActionId, 'D'

IF @Result  != 0 GOTO errh

DELETE T1 FROM TAction T1
WHERE T1.ActionId = @ActionId --AND T1.ConcurrencyId = @ConcurrencyId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:

RETURN (100)

GO
