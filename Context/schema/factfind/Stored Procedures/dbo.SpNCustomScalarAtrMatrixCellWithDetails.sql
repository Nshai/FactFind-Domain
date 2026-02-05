SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpNCustomScalarAtrMatrixCellWithDetails]
 @AtrTemplateGuid uniqueidentifier,  
 @RiskProfileGuid uniqueidentifier,  
 @AtrMatrixTermGuid uniqueidentifier,  
 @ImmediateIncome bit,  
 @ATRRefPortfolioTypeid int  

as
  
SELECT  
atrportfolioguid,b.Identifier as ModelIdentifier, RiskNumber,BriefDescription,Descriptor, d.Identifier as TermDescription,a.RiskProfileGuid
from TAtrMatrixCombined a  
inner join TATRPortfolioCombined b on a.atrportfolioguid = b.guid  
inner join policymanagement..TRiskProfileCombined c on c.Guid = a.RiskProfileGuid
inner join TAtrMatrixTermCombined d on d.guid = a.AtrMatrixTermGuid
WHERE  
 a.AtrTemplateGuid = @AtrTemplateGuid  
 AND RiskProfileGuid = @RiskProfileGuid  
 AND AtrMatrixTermGuid = @AtrMatrixTermGuid  
 AND ImmediateIncome = @ImmediateIncome  
 AND (atrRefPortfolioTypeId = @ATRRefPortfolioTypeid or @ATRRefPortfolioTypeid is null)
GO
