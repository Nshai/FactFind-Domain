SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveAdditionalPropertyDetails] 
AS      
      
   SELECT 1 AS TAG,  
		  NULL AS Parent,  
		  RefAdditionalPropertyDetailId  AS [RefAdditionalPropertyDetail!1! RefAdditionalPropertyDetailId],  
		  [Description] AS [RefAdditionalPropertyDetail!1!Description]  
   FROM factfind..TRefAdditionalPropertyDetail
  
FOR XML EXPLICIT
GO
