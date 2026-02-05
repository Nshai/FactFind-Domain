SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditHousehold]
	@StampUser		VARCHAR (255),
	@HouseholdId	BIGINT,
	@StampAction	CHAR(1)
AS
BEGIN
	INSERT INTO [dbo].[THouseholdAudit] (TenantId, [Name], [Description], ServicingAdvisorId, PointOfContactId, IsArchived, CreatedAt, CreatedBy, StampAction, StampDateTime, StampUser)
	SELECT								       TenantId, [Name], [Description], ServicingAdvisorId, PointOfContactId, IsArchived, CreatedAt, CreatedBy, @StampAction, GETDATE(),    @StampUser
	FROM THousehold
	WHERE 
		HouseholdId = @HouseholdId

	IF @@ERROR != 0 
		GOTO errorHandler

	RETURN (0)

	errorHandler:
	RETURN (100)
END
GO
