SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[SpCustomRetrieveMortgageBenchLicenceDetails] @IndigoClientId bigint

AS

DECLARE @RefApplicationId bigint

SET @RefApplicationId=(SELECT RefApplicationId FROM PolicyManagement..TRefApplication WITH(NOLOCK) WHERE ApplicationNAme='Mortgage Bench' AND ApplicationShortName='MB')

IF ISNULL(@RefApplicationId,0)!=0
BEGIN
	SELECT 1 as Tag,
	NULL AS Parent,
	A.IndigoClientId AS [Licence!1!IndigoClientId],
	ISNULL(A.MaxLicenceCount,0) AS [Licence!1!MaxLicenceCount],
	ISNULL(B.UserCount,0) AS [Licence!1!UserCount]

	FROM PolicyManagement..TApplicationLink A
	LEFT JOIN (
			SELECT IndigoClientId, Count(UserID) 'UserCount'
			FROM Administration..TUser
			WHERE IsMortgageBenchEnabled=1
			AND IndigoCLientId=@IndigoClientId
			GROUP BY IndigoClientId
			) B ON A.IndigoClientId=B.IndigoClientId
	WHERE A.RefApplicationId=@RefApplicationId
	AND A.IndigoClientId=@IndigoClientId
	
ORDER BY [Licence!1!IndigoClientId]

FOR XML EXPLICIT
	
END
GO
