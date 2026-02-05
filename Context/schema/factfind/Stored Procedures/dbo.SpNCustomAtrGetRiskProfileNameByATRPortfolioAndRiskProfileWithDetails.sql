SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpNCustomAtrGetRiskProfileNameByATRPortfolioAndRiskProfileWithDetails]  
@AtrPortfolioGuid uniqueidentifier,  
@RiskProfileGuid uniqueidentifier  
  
as  
  
select distinct
atrportfolioguid,b.Identifier as ModelIdentifier, RiskNumber,BriefDescription,Descriptor, d.Identifier as TermDescription,a.RiskProfileGuid
FROM  
  TAtrMatrixCombined a  
  inner join TAtrPortfolioCombined b on b.guid = a.AtrPortfolioGUID  
  inner join policymanagement..TRiskProfileCombined c on c.guid = a.riskprofileguid  
	inner join TAtrMatrixTermCombined d on d.guid = a.AtrMatrixTermGuid
 WHERE  
  a.AtrPortfolioGuid = @AtrPortfolioGuid
 and a.riskprofileguid = @RiskProfileGuid


GO
