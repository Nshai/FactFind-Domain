SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditHouseholdGroup]
	@StampUser			VARCHAR (255),
	@HouseholdGroupId	BIGINT,
	@StampAction		CHAR(1)
AS
BEGIN
	INSERT INTO THouseholdGroupAudit (HouseholdGroupId, HouseholdId, [Name], StampAction, StampDateTime, StampUser)
	SELECT								    HouseholdGroupId, HouseholdId, [Name], @StampAction, GetDate(),    @StampUser
	FROM THouseholdGroup
	WHERE 
		@HouseholdGroupId = @HouseholdGroupId


	IF @@ERROR != 0 
		GOTO errorHandler

	RETURN (0)

	errorHandler:
	RETURN (100)
END
GO
