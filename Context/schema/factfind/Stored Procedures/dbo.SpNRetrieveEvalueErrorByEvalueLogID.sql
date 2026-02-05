SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveEvalueErrorByEvalueLogID]
	@EvalueLogId bigint
AS

	
select  EvalueErrorId,EvalueLogId,EvalueErrorDescription,EvalueErrorXML,ConcurrencyId
from	TEvalueError
where	EvalueLogID = @EvalueLogId
GO
