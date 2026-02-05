SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveRefMortgageRepaymentMethods] @IndigoClientId bigint  
AS      
      
   SELECT 1 AS TAG,  
   NULL AS Parent,  
   RefMortgageRepaymentMethodId  AS [RefMortgageRepaymentMethod!1!RefMortgageRepaymentMethodId],  
   MortgageRepaymentMethod AS [RefMortgageRepaymentMethod!1!MortgageRepaymentMethod]  
 
FROM TRefMortgageRepaymentMethod
WHERE IndigoClientId=@IndigoClientId  
ORDER BY [RefMortgageRepaymentMethod!1!MortgageRepaymentMethod]  
  
FOR XML EXPLICIT
GO
