SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveRefMortgageSaleTypes] 
AS      
      
   SELECT 1 AS TAG,  
   NULL AS Parent,  
   RefMortgageSaleTypeId  AS [RefMortgageSaleType!1! RefMortgageSaleTypeId],  
   MortgageSaleType AS [RefMortgageSaleType!1!MortgageSaleType]  
 
FROM TRefMortgageSaleType  
ORDER BY [RefMortgageSaleType!1!MortgageSaleType]  
  
FOR XML EXPLICIT
GO
