SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveRefEquityReleaseTypes] 
AS      
      
   SELECT 1 AS TAG,  
		  NULL AS Parent,  
		  RefEquityReleaseTypeId  AS [RefEquityReleaseType!1! RefEquityReleaseTypeId],  
		  EquityReleaseType AS [RefEquityReleaseType!1!EquityReleaseType]  
   FROM crm..TRefEquityReleaseType 
  
FOR XML EXPLICIT
GO
