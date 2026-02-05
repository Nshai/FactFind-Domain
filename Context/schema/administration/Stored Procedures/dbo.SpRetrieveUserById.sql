SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveUserById]
@UserId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.UserId AS [User!1!UserId], 
    T1.Identifier AS [User!1!Identifier], 
    T1.Password AS [User!1!Password], 
    ISNULL(T1.PasswordHistory, '') AS [User!1!PasswordHistory], 
    T1.Email AS [User!1!Email], 
    ISNULL(T1.Telephone, '') AS [User!1!Telephone], 
    T1.Status AS [User!1!Status], 
    T1.GroupId AS [User!1!GroupId], 
    ISNULL(T1.SyncPassword, '') AS [User!1!SyncPassword], 
    ISNULL(CONVERT(varchar(24), T1.ExpirePasswordOn, 120),'') AS [User!1!ExpirePasswordOn], 
    T1.SuperUser AS [User!1!SuperUser], 
    T1.SuperViewer AS [User!1!SuperViewer], 
    T1.FinancialPlanningAccess AS [User!1!FinancialPlanningAccess], 
    T1.FailedAccessAttempts AS [User!1!FailedAccessAttempts], 
    T1.WelcomePage AS [User!1!WelcomePage], 
    ISNULL(T1.Reference, '') AS [User!1!Reference], 
    ISNULL(T1.CRMContactId, '') AS [User!1!CRMContactId], 
    ISNULL(T1.SearchData, '') AS [User!1!SearchData], 
    ISNULL(T1.RecentData, '') AS [User!1!RecentData], 
    ISNULL(T1.RecentWork, '') AS [User!1!RecentWork], 
    ISNULL(T1.IndigoClientId, '') AS [User!1!IndigoClientId], 
    T1.SupportUserFg AS [User!1!SupportUserFg], 
    ISNULL(T1.ActiveRole, '') AS [User!1!ActiveRole], 
    T1.CanLogCases AS [User!1!CanLogCases], 
    T1.RefUserTypeId AS [User!1!RefUserTypeId], 
    T1.Guid AS [User!1!Guid], 
    T1.IsMortgageBenchEnabled AS [User!1!IsMortgageBenchEnabled], 
    T1.ConcurrencyId AS [User!1!ConcurrencyId]
  FROM TUser T1

  WHERE (T1.UserId = @UserId)

  ORDER BY [User!1!UserId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
