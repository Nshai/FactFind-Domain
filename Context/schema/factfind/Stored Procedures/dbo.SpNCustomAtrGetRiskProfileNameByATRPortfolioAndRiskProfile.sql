SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpNCustomAtrGetRiskProfileNameByATRPortfolioAndRiskProfile]  
@AtrPortfolioGuid uniqueidentifier,  
@RiskProfileGuid uniqueidentifier  
  
as  
  
select distinct cast(RiskNumber as varchar(2)) + ' (' + d.Identifier + ')'  
FROM  
  TAtrMatrixCombined a  
  inner join TAtrPortfolio b on b.guid = a.AtrPortfolioGUID  
  inner join policymanagement..TRiskProfileCombined c on c.guid = a.riskprofileguid  
  inner join TATRMatrixTermCombined d on d.guid = atrmatrixtermguid
 WHERE  
  a.AtrPortfolioGuid = @AtrPortfolioGuid  
 and a.riskprofileguid = @RiskProfileGuid  
 
 
GO
