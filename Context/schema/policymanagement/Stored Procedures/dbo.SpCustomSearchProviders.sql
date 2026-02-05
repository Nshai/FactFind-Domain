SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[SpCustomSearchProviders]
@IndigoClientId bigint,
@CorporateName varchar(255) = '%'
AS

DECLARE @IsIndependent bit

SELECT @CorporateName = @CorporateName + '%'
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

   WHERE TCRMContact.CorporateName LIKE @CorporateName 
   AND T1.RetireFg = 0

  ORDER BY [RefProdProvider!1!CorporateName] ASC

  FOR XML EXPLICIT


END

ELSE

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

   FROM TIndigoClientProvider 
   INNER JOIN TRefProdProvider T1 ON T1.RefProdProviderId =  TIndigoClientProvider.RefProdProviderId
   INNER JOIN CRM..TCRMContact TCRMContact ON TCRMContact.CRMContactId = T1.CRMContactId

   WHERE TIndigoClientProvider.IndigoClientId = @IndigoClientId
   AND TCRMContact.CorporateName LIKE @CorporateName 
   AND T1.RetireFg = 0

  ORDER BY [RefProdProvider!1!CorporateName] ASC

  FOR XML EXPLICIT

END
RETURN (0)



GO
