SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpNCustomScalarAtrProfilesForDurationWithDetails]  
 @AtrTemplateGuid uniqueidentifier,   
 @AtrMatrixTermGuid uniqueidentifier,  
 @ImmediateIncome bit,  
 @ATRRefPortfolioTypeId int = 2  
AS  
SELECT  
atrportfolioguid,b.Identifier as ModelIdentifier, RiskNumber,BriefDescription,Descriptor, d.Identifier as TermDescription,a.RiskProfileGuid
from TAtrMatrixCombined a  
inner join TATRPortfolioCombined b on a.atrportfolioguid = b.guid  
inner join policymanagement..TRiskProfileCombined c on c.Guid = a.RiskProfileGuid
inner join TAtrMatrixTermCombined d on d.guid = a.AtrMatrixTermGuid
WHERE  
 a.AtrTemplateGuid = @AtrTemplateGuid  
 AND AtrMatrixTermGuid = @AtrMatrixTermGuid  
 AND ImmediateIncome = @ImmediateIncome  
 AND AtrRefPortfolioTypeId = @ATRRefPortfolioTypeId  
order by risknumber  
GO
