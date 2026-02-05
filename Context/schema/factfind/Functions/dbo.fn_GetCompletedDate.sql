SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fn_GetCompletedDate](@CRMContactId bigint,@RefSystemEvent varchar(255), @TenantId int)
RETURNS DATETIME
AS
BEGIN
DECLARE @RefSystemEventId bigint, @CompletedDate datetime

SELECT @RefSystemEventId = RefSystemEventId
FROM CRM..TRefSystemEvent
WHERE Identifier = @RefSystemEvent

RETURN (
	SELECT TOP 1 DateCompleted
	FROM
		CRM..TTask A
		JOIN CRM..TOrganiserActivity B On A.TaskId = B.TaskId
		JOIN CRM..TActivityCategory2RefSystemEvent C ON B.ActivityCategoryId = C.ActivityCategoryId
	WHERE
		A.IndigoClientId=@TenantId
		AND C.RefSystemEventId = @RefSystemEventId
		AND A.CRMContactId = @CRMContactId
		AND B.CRMContactId = @CRMContactId
		AND B.CompleteFg = 1
	ORDER BY A.TaskId DESC
)
END
GO
