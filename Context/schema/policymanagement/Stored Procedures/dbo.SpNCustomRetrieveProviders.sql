SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveProviders]  
    @RegionCode varchar(2) = null,
    @UseXmlFormat BIT = 1
AS  
  
IF (@UseXmlFormat = 1)
  BEGIN
	SELECT 1 AS TAG,      
		NULL AS Parent,      
		A.RefProdProviderId AS [RefProdProvider!1!RefProdProviderId],      
		B.CorporateName AS [RefProdProvider!1!ProviderName]    
           
    FROM TRefProdProvider A      
		JOIN CRM..TCRMContact B ON A.CRMContactId=B.CRMContactId  
	WHERE A.RetireFg=0
		AND (@RegionCode IS NULL OR A.RegionCode = @RegionCode) 
		AND A.[IsBankAccountTransactionFeed] = 0  
	AND ISNULL(B.CorporateName,'')!='' 
  
	ORDER BY [RefProdProvider!1!ProviderName]  
  
	FOR XML EXPLICIT  

  END
ELSE
  BEGIN
    SELECT 
	   A.RefProdProviderId AS [Id],      
	   B.CorporateName AS [Name]    
           
    FROM TRefProdProvider A      
		JOIN CRM..TCRMContact B ON A.CRMContactId=B.CRMContactId  
	WHERE A.RetireFg=0
		AND (@RegionCode IS NULL OR A.RegionCode = @RegionCode) 
		AND A.[IsBankAccountTransactionFeed] = 0  
		AND ISNULL(B.CorporateName,'')!='' 
  
	ORDER BY [Name]  
  END 
GO
