SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[spNAuditRefEvalueIncreaseTypeAudit]

    @StampUser varchar (255),
	@RefEvalueIncreaseTypeId bigint,
	@StampAction char(1)
AS

	INSERT INTO TRefEvalueIncreaseTypeAudit
           ([IncreaseType]
           ,[RefEvalueIncreaseTypeId]
           ,[ConcurrencyId]          
           ,[StampAction]
           ,[StampDateTime]
           ,[StampUser])
     SELECT
           [IncreaseType]
           ,[RefEvalueIncreaseTypeId]
           ,[ConcurrencyId] 
           ,@StampAction
           ,GetDate()
           ,@StampUser
      FROM TRefEvalueIncreaseType
      WHERE RefEvalueIncreaseTypeId = @RefEvalueIncreaseTypeId
	
GO
