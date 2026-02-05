SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create PROCEDURE [dbo].[SpCustomGetRetirementExistingProvisions]	
	@PartyId bigint,
	@RelatedPartyId bigint = null,
	@TenantId bigint	
AS	

	 select top 1 @PartyId as PartyId, 
		  EmployerHasPensionSchemeFg,
		  MemberOfEmployerPensionSchemeFg, 
		  EligibleToJoinEmployerPensionSchemeFg,
		  DateEligibleToJoinEmployerPensionScheme,
		  WhyNotJoinedFg,
		  (select top 1 SSPContractedOut from  FactFind.dbo.TPostExistingMoneyPurchasePlansQuestions where CRMContactId = @PartyId) as SSPContractedOut
	 from FactFind.dbo.TPreExistingFinalSalaryPensionPlansQuestions
	 where CRMContactId =@PartyId

	 union 

	 select top 1 @RelatedPartyId as PartyId,
			 EmployerHasPensionSchemeFg,
			  MemberOfEmployerPensionSchemeFg, 
			  EligibleToJoinEmployerPensionSchemeFg,
			  DateEligibleToJoinEmployerPensionScheme,
			  WhyNotJoinedFg,
		  (select top 1 SSPContractedOut from  FactFind.dbo.TPostExistingMoneyPurchasePlansQuestions where @RelatedPartyId is not null and CRMContactId = @RelatedPartyId) as SSPContractedOut
	 from FactFind.dbo.TPreExistingFinalSalaryPensionPlansQuestions
	 where @RelatedPartyId is not null and CRMContactId =@RelatedPartyId




GO
