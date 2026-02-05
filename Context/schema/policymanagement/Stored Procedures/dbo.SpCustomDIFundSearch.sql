SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCustomDIFundSearch]
@MexId varchar(50) = '',
@SedolNumber varchar(50)= '',
@FundName varchar(100) = ''

AS

-- Declare @SedolNumber varchar(50), @FundName varchar(100)
-- select @SedolNumber = '70803'

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.FundId AS [Fund!1!FundId], 
    ISNULL(T1.MexId, '') AS [Fund!1!MexId], 
    ISNULL(T1.Sedol, '') AS [Fund!1!Sedol], 
    T1.FundTypeId AS [Fund!1!FundTypeId], 
    ISNULL(T1.ProviderId, '') AS [Fund!1!ProviderId], 
    T1.[Name] AS [Fund!1!Name]

 	FROM PolicyManagement..TFund T1

	WHERE (@MexId = '' OR T1.MexId = @MexId)
				OR
				(@SedolNumber = '' OR T1.Sedol = @SedolNumber)
				OR
				(@FundName = '' AND T1.[Name] = @FundName)

  ORDER BY [Fund!1!FundId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
