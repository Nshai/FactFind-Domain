SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveTaxRates]
	
AS


SELECT 1 AS TAG,    
   NULL AS Parent,    
   A.RefTaxRateId AS [RefTaxRate!1!RefTaxRateId],    
   TRIM(REPLACE(CAST(A.TaxRate as varchar(5)), '.0', ' ')) AS [RefTaxRate!1!TaxRate]  
         
FROM TRefTaxRate A    
WHERE A.IsArchived=0

ORDER BY [RefTaxRate!1!TaxRate]

FOR XML EXPLICIT


GO
