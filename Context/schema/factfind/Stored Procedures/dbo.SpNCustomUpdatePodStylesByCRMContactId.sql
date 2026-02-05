SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].SpNCustomUpdatePodStylesByCRMContactId 

@CRMContactId bigint,
@RefFinancialPlanningPodTypeId bigint

as

update	TFinancialPlanningPodTypeSelection
set		RefFinancialPlanningPodTypeId = @RefFinancialPlanningPodTypeId
where	crmcontactid = @CRMContactId
GO
