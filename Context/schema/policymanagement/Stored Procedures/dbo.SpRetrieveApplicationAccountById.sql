SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveApplicationAccountById]
	@ApplicationAccountId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.ApplicationAccountId AS [ApplicationAccount!1!ApplicationAccountId], 
	T1.RefApplicationId AS [ApplicationAccount!1!RefApplicationId], 
	T1.UserId AS [ApplicationAccount!1!UserId], 
	ISNULL(T1.UserName, '') AS [ApplicationAccount!1!UserName], 
	ISNULL(T1.Password, '') AS [ApplicationAccount!1!Password], 
	T1.ConcurrencyId AS [ApplicationAccount!1!ConcurrencyId],
	T1.Token,
	T1.TokenExpiryDate
	FROM TApplicationAccount T1
	
	WHERE T1.ApplicationAccountId = @ApplicationAccountId
	ORDER BY [ApplicationAccount!1!ApplicationAccountId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
