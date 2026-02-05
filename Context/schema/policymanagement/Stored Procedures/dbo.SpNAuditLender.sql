SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditLender]
	@StampUser varchar (255),
	@LenderId bigint,
	@StampAction char(1)
AS

INSERT INTO [PolicyManagement].[dbo].[TLenderAudit]
            ([LenderName]
            ,[Url]
			,[ConcurrencyId]
			,[LenderId]
			,[StampAction]
			,[StampDateTime]
			,[StampUser]
           )
Select 
	[LenderName]
    ,[Url]		
	,[ConcurrencyId]
	,[LenderId]
	,@StampAction
	,GetDate()
	,@StampUser
FROM [PolicyManagement].[dbo].[TLender]
WHERE LenderId = @LenderId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
