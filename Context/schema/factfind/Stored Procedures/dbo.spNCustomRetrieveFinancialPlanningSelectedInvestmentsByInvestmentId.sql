SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spNCustomRetrieveFinancialPlanningSelectedInvestmentsByInvestmentId]
@InvestmentId bigint,
@InvestmentType varchar(50),
@CRMContactId bigint

as

select s.Description as FPSession, InvestmentType, InvestmentId
from TFinancialPlanningSelectedInvestments i
inner join TFinancialPlanningSession s on s.financialplanningid = i.financialplanningid
inner join TFinancialPlanning fp on fp.financialplanningid = i.financialplanningid
where	InvestmentId = @InvestmentId and
		CRMContactId = @CRMContactId and
		InvestmentType = @InvestmentType and
		IsArchived = 0

GO
