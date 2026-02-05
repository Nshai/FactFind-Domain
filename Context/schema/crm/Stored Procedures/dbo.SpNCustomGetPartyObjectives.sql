
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomGetPartyObjectives]	
	@PartyId BIGINT,
	@RelatedPartyId BIGINT,
	@TenantId BIGINT
AS

--DECLARE @PartyId BIGINT = 4670733
--DECLARE @RelatedPartyId BIGINT = 4670731
--DECLARE @TenantId BIGINT = 10155

SELECT this_.objectiveid							AS ObjectiveId,
       this_.objective								AS Objective,
       objectivet3_.objectivetypeid					AS ObjectiveTypeId,
       objectivet3_.identifier						AS ObjectiveType,
       this_.startdate								AS StartDate,
       this_.targetdate								AS TargetDate,
       riskprofil4_.briefdescription				AS RiskProfile,
       riskprofil4_.risknumber						AS RiskProfileNumber,
       riskprofil4_.descriptor						AS RiskProfileDescription,
       this_.reasonforchange						AS ReasonForChange,
       this_.crmcontactid							AS ClientId,
       ''											AS Client2Id,
       this_.targetamount							AS TargetAmount,
       this_.goaltype								AS GoalTypeId,
       this_.frequency								AS FrequencyId,
	   ISNULL(cl1.CorporateName, ISNULL(cl1.FirstName, '') + ' '+ ISNULL(cl1.LastName, '')) 
													AS Owners,
	   this_.RetirementAge							AS RetirementAge,
	   CASE WHEN ISNULL(this_.GoalType, 0) = 3
			THEN this_.RefLumpsumAtRetirementTypeId			
			ELSE NULL 
	   END											AS LumpsumAtRetirementTypeId,
	   CASE WHEN ISNULL(this_.GoalType, 0) = 3
			THEN this_.LumpSumAtRetirement	
	   		ELSE NULL	
	   END											AS LumpSumAtRetirement,
	   this_.Details								AS Details,
	   category.Name								AS Category,
	   this_.IsAtRetirement							AS IsAtRetirement,
	   this_.TermInYears							AS TermInYears
FROM   factfind.dbo.[tobjective] this_
       LEFT OUTER JOIN policymanagement.dbo.[triskprofilecombined] riskprofil4_
                    ON this_.riskprofileguid = riskprofil4_.guid
       LEFT OUTER JOIN factfind.dbo.[tobjectivetype] objectivet3_
                    ON this_.objectivetypeid = objectivet3_.objectivetypeid
	   LEFT OUTER JOIN factfind.dbo.TRefGoalCategory category
                    ON this_.RefGoalCategoryId = category.RefGoalCategoryId
	   JOIN crm.dbo.TCRMContact cl1 On this_.CRMContactId = cl1.CRMContactId  

WHERE  cl1.CRMContactId in (@PartyId, @RelatedPartyId) AND cl1.IndClientId = @TenantId AND ISNULL(this_.crmcontactid2, 0) = 0

UNION 

SELECT this_.objectiveid							AS ObjectiveId,
       this_.objective								AS Objective,
       objectivet3_.objectivetypeid					AS ObjectiveTypeId,
       objectivet3_.identifier						AS ObjectiveType,
       this_.startdate								AS StartDate,
       this_.targetdate								AS TargetDate,
       riskprofil4_.briefdescription				AS RiskProfile,
       riskprofil4_.risknumber						AS RiskProfileNumber,
       riskprofil4_.descriptor						AS RiskProfileDescription,
       this_.reasonforchange						AS ReasonForChange,
       this_.crmcontactid							AS ClientId,
       this_.crmcontactid2							AS Client2Id,
       this_.targetamount							AS TargetAmount,
       this_.goaltype								AS GoalTypeId,
       this_.frequency								AS FrequencyId,
	   ISNULL(cl1.CorporateName, ISNULL(cl1.FirstName, '') + ' '+ ISNULL(cl1.LastName, '')) +' & '+
	   ISNULL(cl2.CorporateName, ISNULL(cl2.FirstName, '') + ' '+ ISNULL(cl2.LastName, ''))
													AS Owners,
	   this_.RetirementAge							AS RetirementAge,
	   CASE WHEN ISNULL(this_.GoalType, 0) = 3
			THEN this_.RefLumpsumAtRetirementTypeId			
			ELSE NULL 
	   END											AS LumpsumAtRetirementTypeId,
	   CASE WHEN ISNULL(this_.GoalType, 0) = 3 
			THEN this_.LumpSumAtRetirement	
	   		ELSE NULL	
	   END											AS LumpSumAtRetirement,
	   this_.Details								AS Details,
	   category.Name								AS Category,
	   this_.IsAtRetirement							AS IsAtRetirement,
	   this_.TermInYears							AS TermInYears
FROM   factfind.dbo.[tobjective] this_
       LEFT OUTER JOIN policymanagement.dbo.[triskprofilecombined] riskprofil4_
                    ON this_.riskprofileguid = riskprofil4_.guid
       LEFT OUTER JOIN factfind.dbo.[tobjectivetype] objectivet3_
                    ON this_.objectivetypeid = objectivet3_.objectivetypeid
	     LEFT OUTER JOIN factfind.dbo.TRefGoalCategory category
                    ON this_.RefGoalCategoryId = category.RefGoalCategoryId
	   JOIN crm.dbo.TCRMContact cl1 On this_.CRMContactId = cl1.CRMContactId
	   JOIN crm.dbo.TCRMContact cl2 On this_.CRMContactId2 = cl2.CRMContactId
WHERE cl1.IndClientId = @TenantId and cl1.CRMContactId = @PartyId AND   cl2.CRMContactId =  @RelatedPartyId
UNION
SELECT this_.objectiveid							AS ObjectiveId,
       this_.objective								AS Objective,
       objectivet3_.objectivetypeid					AS ObjectiveTypeId,
       objectivet3_.identifier						AS ObjectiveType,
       this_.startdate								AS StartDate,
       this_.targetdate								AS TargetDate,
       riskprofil4_.briefdescription				AS RiskProfile,
       riskprofil4_.risknumber						AS RiskProfileNumber,
       riskprofil4_.descriptor						AS RiskProfileDescription,
       this_.reasonforchange						AS ReasonForChange,
       this_.crmcontactid							AS ClientId,
       this_.crmcontactid2							AS Client2Id,
       this_.targetamount							AS TargetAmount,
       this_.goaltype								AS GoalTypeId,
       this_.frequency								AS FrequencyId,
	   ISNULL(cl1.CorporateName, ISNULL(cl1.FirstName, '') + ' '+ ISNULL(cl1.LastName, '')) +' & '+
	   ISNULL(cl2.CorporateName, ISNULL(cl2.FirstName, '') + ' '+ ISNULL(cl2.LastName, ''))
													AS Owners,
	   this_.RetirementAge							AS RetirementAge,
	   CASE WHEN ISNULL(this_.GoalType, 0) = 3
			THEN this_.RefLumpsumAtRetirementTypeId			
			ELSE NULL 
	   END											AS LumpsumAtRetirementTypeId,
	   CASE WHEN ISNULL(this_.GoalType, 0) = 3 
			THEN this_.LumpSumAtRetirement	
	   		ELSE NULL	
	   END											AS LumpSumAtRetirement,
	   this_.Details								AS Details,
	   category.Name								AS Category,
	   this_.IsAtRetirement							AS IsAtRetirement,
	   this_.TermInYears							AS TermInYears
FROM   factfind.dbo.[tobjective] this_
       LEFT OUTER JOIN policymanagement.dbo.[triskprofilecombined] riskprofil4_
                    ON this_.riskprofileguid = riskprofil4_.guid
       LEFT OUTER JOIN factfind.dbo.[tobjectivetype] objectivet3_
                    ON this_.objectivetypeid = objectivet3_.objectivetypeid
	   LEFT OUTER JOIN factfind.dbo.TRefGoalCategory category
                    ON this_.RefGoalCategoryId = category.RefGoalCategoryId
	   JOIN crm.dbo.TCRMContact cl1 On this_.CRMContactId = cl1.CRMContactId
	   JOIN crm.dbo.TCRMContact cl2 On this_.CRMContactId2 = cl2.CRMContactId
WHERE cl1.IndClientId = @TenantId and cl1.CRMContactId = @RelatedPartyId AND   cl2.CRMContactId =  @PartyId

