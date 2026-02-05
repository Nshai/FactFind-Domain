SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateEvaluePensionForecast]
	@StampUser varchar (255),
	@EValueLogId bigint = NULL, 
	@TaxYearStart int = NULL, 
	@TaxYearEnd int = NULL, 
	@EvaluePensionForecastXML xml  = NULL	
AS


DECLARE @EvaluePensionForecastId bigint, @Result int
			
	
INSERT INTO TEvaluePensionForecast
(EValueLogId, TaxYearStart, TaxYearEnd, EvaluePensionForecastXML, ConcurrencyId)
VALUES(@EValueLogId, @TaxYearStart, @TaxYearEnd, @EvaluePensionForecastXML, 1)

SELECT @EvaluePensionForecastId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh


Execute @Result = dbo.SpNAuditEvaluePensionForecast @StampUser, @EvaluePensionForecastId, 'C'

IF @Result  != 0 GOTO errh



IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
