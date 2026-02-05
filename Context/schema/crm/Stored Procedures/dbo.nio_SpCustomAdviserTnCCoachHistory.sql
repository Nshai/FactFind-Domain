SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[nio_SpCustomAdviserTnCCoachHistory]
@IndClientId bigint = 0,
@AdviserId bigint = 0
AS

SELECT 
T1.TnCCoachId AS [TnCCoachId],
T2.UserId AS [UserId],
T1.PractitionerId AS [AdviserId],
T3.CRMContactID AS [CRMContactId],
T4.FirstName + ' ' + T4.LastName AS [TnCCoachName], 
T6.FirstName + ' ' + T6.LastName AS [UpDatedByUserName],
Convert(Datetime, T1.StampDateTime, 120) AS [UpDatedOnDate]

FROM (Select AuditId, TnCCoachId, PractitionerId, StampUser, StampDateTime
	From CRM.dbo.TPractitionerAudit 
	Where AuditId In (
		Select AuditId = Min(B.AuditId)
		From CRM.dbo.TPractitioner A
		Inner Join CRM.dbo.TPractitionerAudit B On A.PractitionerId = B.PractitionerId
		Where A.IndClientId = @IndClientId And A.PractitionerId = @AdviserId And 
A.TnCCoachId <> B.TnCCoachId
		And IsNull(B.TnCCoachId,0) <> 0
		Group By B.TnCCoachId
		)
	) T1

INNER JOIN [Compliance].[dbo].TTnCCoach T2
ON T1.TnCCoachId = T2.TnCCoachId

-- Link for TnCCoach Name
INNER JOIN [Administration].[dbo].TUser T3
ON T2.UserId = T3.UserId

INNER JOIN [CRM].[dbo].TCRMContact T4
ON T3.CRMContactId = T4.CRMContactId

-- Link for Updated By User Name
INNER JOIN [Administration].[dbo].TUser T5
ON T1.StampUser = T5.UserId

INNER JOIN [CRM].[dbo].TCRMContact T6
ON T5.CRMContactId = T6.CRMContactId
GO
