SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spNCustomRetrieveEValuePension]
	@CRMContactId bigint, 
	@CRMContactId2 bigint
AS

select isnull(sum(BasicAnnualAmount),0) + isnull(sum(AdditionalAnnualAmount),0) as TotalPensionAmount
from TFinancialPlanningStatePension
where	CRMContactId in (@CRMContactId,@CRMContactId2)
GO
