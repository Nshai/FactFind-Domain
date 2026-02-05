SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomListMultiTieProviders]  
@IndigoClientId bigint  
AS  
  
  
BEGIN  
  SELECT DISTINCT  
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
   INNER JOIN TMultiTie T2 ON T1.RefProdProviderId = t2.RefProdProviderId  
   WHERE T1.RetireFg = 0  
   AND T2.IndigoClientId = @IndigoClientId  
  
  
  
  ORDER BY [RefProdProvider!1!CorporateName] ASC  
  
  FOR XML EXPLICIT  
  
END  
GO
