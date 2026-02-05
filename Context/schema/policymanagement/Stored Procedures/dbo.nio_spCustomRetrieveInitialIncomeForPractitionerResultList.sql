SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_spCustomRetrieveInitialIncomeForPractitionerResultList]
(		
	@AdviserCRMContactId bigint	
)

AS


Select 1 as Id, 
	'' as BusinessType,
	1 as Owner1CRMContactId,
	'' as Owner1Name,
	2 as Owner2CRMContactId,
	'' as Owner2Name,
	'' as IncomeType,
	1 as FeeId,
	'' as FeeRef,
	'' as FeeStatus,
	1 as PolicyBusinessId,
	'' as PolicyRef,
	'' as PlanStatus,
	'' as Provider,
	'' as PlanType,
	convert(money, 0) as ExpectedInitialIncome,
	convert(money, 0) as ReceivedInitialIncome,
	convert(money, 0) as OutstandingInitialIncome


