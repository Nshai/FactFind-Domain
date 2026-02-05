SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomRetrieveRiskReturnForTerm] @term int  , @atrTemplateGuid uniqueidentifier  
    
as    
    
select RiskProfileId,Term,AverageAnnualReturn,AverageVolatilityReturn    
from VwAverageVolalityAndReturn    
where @term = Term  and @atrTemplateGuid = returnTemplateGuid and   @atrTemplateGuid = riskTemplateGuid
order by RiskProfileId 
GO
