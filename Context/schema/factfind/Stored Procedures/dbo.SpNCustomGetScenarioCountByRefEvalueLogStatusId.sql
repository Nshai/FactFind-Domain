SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomGetScenarioCountByRefEvalueLogStatusId]
@UserName varchar (255),
@UserPassword varchar (255),
@RefEvalueLogStatusId smallint

AS

select isnull(count(*),0) as cnt
from	TEvalueScenario s
inner join  TEvalueLog l on l.EvalueLogId = s.EvalueLogId
where	RefEvalueLogStatusId = @RefEvalueLogStatusId and
		l.UserName = @UserName and
		l.UserPassword = @UserPassword

errh:
RETURN (100)
GO
