SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditHouseholdPlan]
	@StampUser			VARCHAR (255),
	@HouseholdPlanId	BIGINT,
	@StampAction		CHAR(1)
AS
BEGIN
	INSERT INTO THouseholdPlanAudit (HouseholdPlanId, PolicyBusinessId, HouseholdId, HouseholdGroupId, StampAction, StampDateTime, StampUser)
	SELECT								   HouseholdPlanId, PolicyBusinessId, HouseholdId, HouseholdGroupId, @StampAction, GETDATE(),    @StampUser
	FROM THouseholdPlan
	WHERE 
		HouseholdPlanId = @HouseholdPlanId


	IF @@ERROR != 0 
		GOTO errorHandler

	RETURN (0)

	errorHandler:
	RETURN (100)
END
GO

