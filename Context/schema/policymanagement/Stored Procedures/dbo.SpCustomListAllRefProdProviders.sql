SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomListAllRefProdProviders]  
@IndigoClientId bigint,  
@ExcludeRefProdProviderId bigint = -1  
AS  
  
  
DECLARE @IsIndependent bit  
  
SELECT @IsIndependent = IsIndependent FROM [administration].dbo.TIndigoClient WHERE IndigoClientId = @IndigoClientId  
  
IF @IsIndependent = 1  
BEGIN  
  SELECT  
    1 AS Tag,  
    NULL AS Parent,  
    T1.RefProdProviderId AS [RefProdProvider!1!RefProdProviderId],   
    TCRMContact.CorporateName AS [RefProdProvider!1!CorporateName],  
    ISNULL(T1.CRMContactId, '') AS [RefProdProvider!1!CRMContactId],    
    ISNULL(T1.FundProviderId, '') AS [RefProdProvider!1!FundProviderId],   
    ISNULL(T1.NewProdProviderId, '') AS [RefProdProvider!1!NewProdProviderId],   
    ISNULL(T1.RetireFg, '') AS [RefProdProvider!1!RetireFg],   
    T1.ConcurrencyId AS [RefProdProvider!1!ConcurrencyId]  
  
   FROM TRefProdProvider T1  
   INNER JOIN CRM..TCRMContact TCRMContact ON TCRMContact.CRMContactId = T1.CRMContactId  
  
   WHERE T1.RetireFg = 0  
   AND T1.RefProdProviderId <> @ExcludeRefProdProviderId  
  
  ORDER BY [RefProdProvider!1!CorporateName] ASC  
  
  FOR XML EXPLICIT  
END  
ELSE  
BEGIN  
  SELECT  
    1 AS Tag,  
    NULL AS Parent,  
    T1.RefProdProviderId AS [RefProdProvider!1!RefProdProviderId],   
    ISNULL(T3.CorporateName, '') AS [RefProdProvider!1!CorporateName],   
    ISNULL(T1.CRMContactId, '') AS [RefProdProvider!1!CRMContactId],    
    ISNULL(T1.FundProviderId, '') AS [RefProdProvider!1!FundProviderId],   
    ISNULL(T1.NewProdProviderId, '') AS [RefProdProvider!1!NewProdProviderId],   
    ISNULL(T1.RetireFg, '') AS [RefProdProvider!1!RetireFg],   
    T1.ConcurrencyId AS [RefProdProvider!1!ConcurrencyId]  
  
  FROM [CRM].[dbo].TCRMContact T3  
  INNER JOIN TRefProdProvider T1  
  ON T3.CRMContactId = T1.CRMContactId  
  INNER JOIN TIndigoClientProvider TIndigoClientProvider  
  ON T1.RefProdProviderId = TIndigoClientProvider.RefProdProviderId  
  WHERE (TIndigoClientProvider.IndigoClientId = @IndigoClientId)  
  AND T1.RefProdProviderId <> @ExcludeRefProdProviderId  
  
  
  ORDER BY [RefProdProvider!1!CorporateName]  
  
  FOR XML EXPLICIT  
  
END  
  
  
GO
