SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveEvaluePensionForecastByEvalueLogId]	
	@EValueLogId bigint = NULL	
AS


select 
EvaluePensionForecastId,
EValueLogId,
TaxYearStart,
TaxYearEnd,
EvaluePensionForecastXML,
ConcurrencyId
from TEvaluePensionForecast
where EValueLogId = @EValueLogId
GO
