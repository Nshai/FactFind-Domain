SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[spNAuditEvalueIncreaseTypeToEscalationTypeAudit]

    @StampUser varchar (255),
	@EvalueIncreaseTypeToEscalationTypeId bigint,
	@StampAction char(1)
AS

	INSERT INTO TEvalueIncreaseTypeToEscalationTypeAudit
           (
           [RefEvalueIncreaseTypeId]
		   , [RefEscalationTypeId]
           ,[ConcurrencyId]   
		   ,[EvalueIncreaseTypeToEscalationTypeId]       
           ,[StampAction]
           ,[StampDateTime]
           ,[StampUser])
     SELECT           
           [RefEvalueIncreaseTypeId]
		   , [RefEscalationTypeId]
           ,[ConcurrencyId]   
		   ,[EvalueIncreaseTypeToEscalationTypeId]
           ,@StampAction
           ,GetDate()
           ,@StampUser
      FROM TEvalueIncreaseTypeToEscalationType
      WHERE EvalueIncreaseTypeToEscalationTypeId = @EvalueIncreaseTypeToEscalationTypeId
	
GO
