SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEvaluePensionForecast]
	@StampUser varchar (255),
	@EvaluePensionForecastId bigint,
	@StampAction char(1)
AS

INSERT INTO TEvaluePensionForecastAudit 
( EValueLogId, TaxYearStart, TaxYearEnd, EvaluePensionForecastXML, 
		ConcurrencyId, 
	EvaluePensionForecastId, StampAction, StampDateTime, StampUser) 
Select EValueLogId, TaxYearStart, TaxYearEnd, EvaluePensionForecastXML, 
		ConcurrencyId, 
	EvaluePensionForecastId, @StampAction, GetDate(), @StampUser
FROM TEvaluePensionForecast
WHERE EvaluePensionForecastId = @EvaluePensionForecastId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
