SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditImageTypeToOutputType]
	@StampUser varchar (255),
	@ImageTypeToOutputTypeId int,
	@StampAction char(1)
AS

INSERT INTO [dbo].[TImageTypeToOutputTypeAudit]
           ([ImageTypeToOutputTypeId]
           ,[FinancialPlanningImageTypeId]
           ,[FinancialPlanningOutputTypeId]
           ,[ConcurrencyId]
           ,[StampAction]
           ,[StampDateTime]
           ,[StampUser])

SELECT [ImageTypeToOutputTypeId]
      ,[FinancialPlanningImageTypeId]
      ,[FinancialPlanningOutputTypeId]
      ,[ConcurrencyId]
	  ,@StampAction
	  ,GetDate()
	  ,@StampUser
FROM [dbo].[TImageTypeToOutputType]
WHERE ImageTypeToOutputTypeId = @ImageTypeToOutputTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
