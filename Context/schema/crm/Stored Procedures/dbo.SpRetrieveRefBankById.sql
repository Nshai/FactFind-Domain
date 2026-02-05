SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefBankById]
	@RefBankId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.RefBankId AS [RefBank!1!RefBankId], 
	T1.Name AS [RefBank!1!Name], 
	T1.ConcurrencyId AS [RefBank!1!ConcurrencyId]
	FROM TRefBank T1
	
	WHERE T1.RefBankId = @RefBankId
	ORDER BY [RefBank!1!RefBankId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
