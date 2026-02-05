SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpCustomSearchAdvisersColumnList]
AS
SELECT  
	0 AS [PractitionerId],    
	0 AS [PartyId],   
	'' AS FirstName,        
	'' AS LastName,         
	'' AS [AdviserName],        
	'' AS [GroupingName],     
	'' AS [GroupName],    
	'' AS [UserName],    
	CAST(0 as bit) AS [AuthorisedFG],    
	'' AS [Reference],
	'' AS [AdviserRef]  
GO
