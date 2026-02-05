SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveRefEquityLoanSchemes] 
AS      
      
   SELECT 1 AS TAG,  
		  NULL AS Parent,  
		  RefEquityLoanSchemeId  AS [RefEquityLoanScheme!1! RefEquityLoanSchemeId],  
		  [Name] AS [RefEquityLoanScheme!1!RefEquityLoanScheme]  
   FROM policymanagement..TRefEquityLoanScheme
  
FOR XML EXPLICIT
GO