SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditNeedsAndPriorities]
	@StampUser varchar (255),
	@NeedsAndPrioritiesId bigint,
	@StampAction char(1)
AS

INSERT INTO [TNeedsAndPrioritiesAudit]
           ([NeedsAndPrioritiesId]
           ,[ConcurrencyId]
           ,[FactFindId]
           ,[CategoryId]
           ,[TenantId]
           ,[ClientsHaveTheSameAnswers]
           ,[StampAction]
           ,[StampDateTime]
           ,[StampUser])
     SELECT
            [NeedsAndPrioritiesId]
           ,[ConcurrencyId]
           ,[FactFindId]
           ,[CategoryId]
           ,[TenantId]
           ,[ClientsHaveTheSameAnswers]
           ,@StampAction
           ,GETUTCDATE()
           ,@StampUser 
	FROM 
		TNeedsAndPriorities
	WHERE 
		NeedsAndPrioritiesId = @NeedsAndPrioritiesId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
