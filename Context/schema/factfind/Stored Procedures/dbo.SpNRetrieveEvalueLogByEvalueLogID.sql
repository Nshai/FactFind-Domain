SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveEvalueLogByEvalueLogID]
	@EvalueLogId bigint
AS

	
select EvalueLogID,UserName, UserPassword, DateRan, ModellingStatus, RefEvalueLogStatusId, ConcurrencyId
from	TEvalueLog
where	EvalueLogID = @EvalueLogId
GO
