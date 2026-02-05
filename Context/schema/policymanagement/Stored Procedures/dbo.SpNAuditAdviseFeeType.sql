SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditAdviseFeeType]
	@StampUser varchar (255),
	@AdviseFeeTypeId bigint,
	@StampAction char(1)
AS
BEGIN

	INSERT INTO
		dbo.TAdviseFeeTypeAudit
		([Name]
		, [TenantId]
		, [IsArchived]
		, [ConcurrencyId]
		, [AdviseFeeTypeId]
		, [StampAction]
		, [StampDateTime]
		, [StampUser]
		, [IsRecurring]
		, [GroupId]
		, [RefAdviseFeeTypeId]
		, IsSystemDefined)	
	SELECT
	 	 [Name]
	 	 , [TenantId]
	 	 , [IsArchived]
	 	 , [ConcurrencyId]
	 	 , [AdviseFeeTypeId]
	 	 , @StampAction
	 	 , GetDate()
	 	 , @StampUser
	 	 , [IsRecurring]
	 	 , [GroupId]
	 	 , [RefAdviseFeeTypeId]
	 	 , IsSystemDefined
	FROM 
		dbo.TAdviseFeeType
	WHERE 
		AdviseFeeTypeId = @AdviseFeeTypeId
END

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
