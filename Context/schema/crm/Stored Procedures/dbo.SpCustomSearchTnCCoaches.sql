SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomSearchTnCCoaches]
@IndigoClientId bigint,
@FirstName varchar(50)='%',
@LastName varchar(50)='%'

AS

if @FirstName <> '%'
	Select  @FirstName = @FirstName + '%'

if @LastName <> '%'
	Select  @LastName = @LastName + '%'


BEGIN
SELECT Distinct
   1 AS Tag,
   NULL AS Parent,
   T6.TnCCoachId AS [TnCCoach!1!TnCCoachId],
   T6.UserId AS [TnCCoach!1!UserId],
   T1.CRMContactId AS [TnCCoach!1!CRMContactId],
   T2.FirstName + ' ' + T2.LastName AS [TnCCoach!1!FullName],
   T4.Identifier AS [TnCCoach!1!GroupingName], 
   T3.Identifier AS [TnCCoach!1!GroupName]

  FROM [Compliance].[dbo].TTnCCoach T6
  INNER JOIN [Administration].[dbo].TUser T1
  ON T6.UserId  = T1.UserId

  INNER JOIN [CRM].[dbo].TCRMContact T2
  ON T2.CRMContactId = T1.CRMContactId

  INNER JOIN [Administration].[dbo].TGroup T3
  ON T3.GroupId = T1.GroupId

  INNER JOIN [Administration].[dbo].TGrouping T4
  ON T4.GroupingId = T3.GroupingId

   WHERE T1.IndigoClientId = @IndigoClientId
   AND T2.FirstName LIKE @FirstName
   AND T2.LastName LIKE @LastName
   AND T6.Status = 'Active'

  FOR XML EXPLICIT

END
RETURN 0







GO
