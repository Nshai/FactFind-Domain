SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[VwAverageVolalityAndReturn] as  
  
--NOTE 1 is added to the average annual return to take in to account the initial value of the investment. (stake plus winnings)  
select a.RiskProfileId, b.Term, AverageAnnualReturn + 1 as AverageAnnualReturn,AverageVolatilityReturn,a.ATRTemplateGuid as returnTemplateGuid,
b.ATRTemplateGuid as riskTemplateGuid
from TRefAverageVolatilityReturn a  
inner join TRefAverageAnnualReturn b on b.riskprofileid = a.riskprofileid and b.term = a.term
GO
