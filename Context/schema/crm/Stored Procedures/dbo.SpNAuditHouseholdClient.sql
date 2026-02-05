SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditHouseholdClient]
	@StampUser				VARCHAR (255),
	@HouseholdClientId	BIGINT,
	@StampAction			CHAR(1)
AS
BEGIN
	INSERT INTO [dbo].[THouseholdClientAudit] (HouseholdClientId, HouseholdId, CrmContactId, StampAction, StampDateTime, StampUser)
	SELECT								             HouseholdClientId, HouseholdId, CrmContactId, @StampAction, GETDATE(),    @StampUser
	FROM THouseholdClient
	WHERE 
		HouseholdClientId = @HouseholdClientId

	IF @@ERROR != 0 
		GOTO errorHandler

	RETURN (0)

	errorHandler:
	RETURN (100)
END
GO
