SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomDeleteRetirementObjective]
	@RetirementObjectiveId Bigint,
	@ConcurrencyId int,
	@StampUser varchar (255)
AS
	EXEC CRM..SpDeleteOpportunityObjectiveByObjectiveId  @RetirementObjectiveId, @StampUser
	EXEC SpNDeleteObjective @RetirementObjectiveId, @ConcurrencyId, @StampUser
GO
