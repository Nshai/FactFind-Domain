SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




create PROCEDURE [dbo].[SpCustomGetRetirementGoalsAndNeeds]	

	@PartyId bigint,
	@RelatedPartyId bigint = null,
	@TenantId bigint	

AS	


	SELECT
	 (select GoalsAndNeeds from FactFind.dbo.TRetirementGoalsNeeds
	WHERE CRMContactId = @PartyId ) AS GoalsAndNeeds,

	(select RequiredIncome from FactFind.dbo.TRetirementGoalsNeedsQuestion
	WHERE CRMContactId = @PartyId ) AS Client1Income,

	(select RequiredIncome from FactFind.dbo.TRetirementGoalsNeedsQuestion
	WHERE @RelatedPartyId >0 and CRMContactId = @RelatedPartyId ) AS Client2Income
	 

GO
