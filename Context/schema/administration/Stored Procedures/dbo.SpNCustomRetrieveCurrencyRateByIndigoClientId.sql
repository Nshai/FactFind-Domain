SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveCurrencyRateByIndigoClientId] 
@IndigoClientId bigint    
AS    
    
BEGIN    
  SELECT    
    T1.CurrencyRateId,     
    T1.IndigoClientId,     
    T1.CurrencyCode,     
    T2.Description,     
    T1.Rate,    
    T2.Symbol,     
    CONVERT(varchar(24), T1.Date, 120),     
    T1.ConcurrencyId  
  FROM TCurrencyRate T1    
  INNER JOIN TRefCurrency T2 ON T1.CurrencyCode = T2.CurrencyCode    
    
  --WHERE (T1.IndigoClientId = @IndigoClientId)    
WHERE (T1.IndigoClientId = 0)    
    
  ORDER BY T2.CurrencyCode   
    
    
END    
RETURN (0)
GO
