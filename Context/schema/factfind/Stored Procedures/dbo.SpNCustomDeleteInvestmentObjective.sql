SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomDeleteInvestmentObjective]
	@InvestmentObjectiveId Bigint,
	@ConcurrencyId int,
	@StampUser varchar (255)
AS
	EXEC CRM..SpDeleteOpportunityObjectiveByObjectiveId @InvestmentObjectiveId, @StampUser
	EXEC SpNDeleteObjective @InvestmentObjectiveId, @ConcurrencyId, @StampUser
GO
