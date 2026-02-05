SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditValProviderHoursOfOperation]
	@StampUser varchar (255),
	@ValProviderHoursOfOperationId bigint,
	@StampAction char(1)
AS

INSERT INTO TValProviderHoursOfOperationAudit 
( RefProdProviderId, AlwaysAvailableFg, DayOfTheWeek, StartHour, 
		EndHour, StartMinute, EndMinute, ConcurrencyId, 
		
	ValProviderHoursOfOperationId, StampAction, StampDateTime, StampUser) 
Select RefProdProviderId, AlwaysAvailableFg, DayOfTheWeek, StartHour, 
		EndHour, StartMinute, EndMinute, ConcurrencyId, 
		
	ValProviderHoursOfOperationId, @StampAction, GetDate(), @StampUser
FROM TValProviderHoursOfOperation
WHERE ValProviderHoursOfOperationId = @ValProviderHoursOfOperationId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
