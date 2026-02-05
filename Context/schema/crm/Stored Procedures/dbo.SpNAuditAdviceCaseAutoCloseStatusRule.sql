SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAdviceCaseAutoCloseStatusRule]
	@StampUser varchar (255),
	@AdviceCaseAutoCloseStatusRuleId bigint,
	@StampAction char(1)
AS

INSERT INTO TAdviceCaseAutoCloseStatusRuleAudit
           (NumberOfDays
           ,AdviceCaseAutoCloseRule
           ,IndigoClientId
           ,ConcurrencyId
           ,AdviceCaseAutoCloseStatusRuleId
           ,StampAction
           ,StampDateTime
           ,StampUser
           ,HasReopenRule
           ,ReopenNumberOfDays)
     SELECT NumberOfDays
           ,AdviceCaseAutoCloseRule
           ,IndigoClientId
           ,ConcurrencyId
           ,AdviceCaseAutoCloseStatusRuleId
           ,@StampAction
           ,GetDate()
           ,@StampUser
		   ,HasReopenRule
		   ,ReopenNumberOfDays
	FROM TAdviceCaseAutoCloseStatusRule
	WHERE AdviceCaseAutoCloseStatusRuleId = @AdviceCaseAutoCloseStatusRuleId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
