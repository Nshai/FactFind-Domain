SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveUnAvailableComponents]        
@UserId bigint,@IndigoClientId bigint

        
AS  
        
BEGIN        
    	SELECT 1 AS Tag,        
	NULL AS Parent, 
	TDC.DashboardComponentId AS [DashboardComponent!1!DashboardComponentId],
	TDC.Identifier AS [DashboardComponent!1!Identifier],
	TDC.Description AS [DashboardComponent!1!Description],
	TDC.ConcurrencyId AS [DashboardComponent!1!ConcurrencyId]

	FROM    
	TDashboardComponent TDC
	JOIN TDashboardSecurity TDS ON TDC.DashboardComponentId=TDS.DashboardComponentId
	JOIN TUser TU ON TDS.RoleId=TU.ActiveRole
	WHERE TU.UserId=@UserId
	AND TU.SuperUser=0
	AND TDS.IsAllowed=0

	ORDER BY TDC.DashboardComponentId
        
  
	FOR XML EXPLICIT        
        
END        
RETURN (0)  
GO
