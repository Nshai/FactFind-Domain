SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
create  PROCEDURE [dbo].[SpNCustomRetrieveContributions]  
@PolicyBusinessId bigint  
AS  
  
SELECT  
T1.PolicyMoneyInId,   
T1.PolicyBusinessId,   
ISNULL(CONVERT(varchar(24), T1.Amount), '') AS Amount,   
T1.RefFrequencyId,   
T3.FrequencyName,
ISNULL(T1.RefContributionTypeId, '') AS RefContributionTypeId,   
T4.RefContributionTypeName,
ISNULL(T1.RefContributorTypeId, '') AS RefContributorTypeId,    
T5.RefContributorTypeName
FROM policymanagement..TPolicyMoneyIn T1  
INNER JOIN policymanagement..TPolicyBusiness T2 ON T1.PolicyBusinessId = T2.PolicyBusinessId  
INNER JOIN policymanagement..TRefFrequency T3 ON T1.RefFrequencyId = T3.RefFrequencyId  
INNER JOIN policymanagement..TRefContributionType T4 ON T1.RefContributionTypeId = T4.RefContributionTypeId  
INNER JOIN policymanagement..TRefContributorType T5  ON T1.RefContributorTypeId = T5.RefContributorTypeId  
WHERE (T1.PolicyBusinessId = @PolicyBusinessId)  
  


GO
