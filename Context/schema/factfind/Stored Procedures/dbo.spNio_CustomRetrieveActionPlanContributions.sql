SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  

  

      

CREATE procedure [dbo].[spNio_CustomRetrieveActionPlanContributions]        

        

@ActionPlanIds varchar(max)      

        

as        

  

Declare @ParsedValues Table ( Id int, ParsedValue varchar(200) )    

Insert Into @ParsedValues(Id, ParsedValue)  

Exec Administration.dbo.SpCustomParseCsvStringToStringList @CommaSeperatedList = @ActionPlanIds  

  

Select ActionPlanContributionId, ActionPlanId, ContributionAmount,   

 a.RefContributionTypeId, B.RefContributionTypeName,  

 a.RefContributorTypeId, C.RefContributorTypeName,  

 ContributionFrequency, A.StopContribution, A.IsIncreased  

From TActionPlanContribution A  

Join PolicyManagement..TRefContributionType B on a.RefContributionTypeId = B.RefContributionTypeId  

Join PolicyManagement..TRefContributorType C on a.RefContributorTypeId = c.RefContributorTypeId  

Where ActionPlanId in (Select ParsedValue From @ParsedValues)  

  

  
GO
