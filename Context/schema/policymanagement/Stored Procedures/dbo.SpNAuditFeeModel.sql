SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditFeeModel]
	@StampUser varchar (255),
	@FeeModelId bigint,
	@StampAction char(1)
AS

	INSERT INTO 
		TFeeModelAudit 
		(Name, 
		StartDate, 
		EndDate, 
		RefFeeModelStatusId, 
		IsDefault, 
		TenantId, 
		ConcurrencyId, 
		FeeModelId, 
		StampAction, 
		StampDateTime, 
		StampUser,
		GroupId, 
		IsPropagated,
		IsSystemDefined,
		IsArchived) 
	SELECT 
		Name, 
		StartDate, 
		EndDate, 
		RefFeeModelStatusId, 
		IsDefault, 
		TenantId, 
		ConcurrencyId, 
		FeeModelId, 
		@StampAction, 
		GetDate(), 
		@StampUser,
		GroupId, 
		IsPropagated,
		IsSystemDefined,
		IsArchived
	FROM 
		TFeeModel
	WHERE 
		FeeModelId = @FeeModelId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
