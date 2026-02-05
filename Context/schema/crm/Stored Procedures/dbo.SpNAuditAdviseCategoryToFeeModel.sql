SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditAdviseCategoryToFeeModel]
	@StampUser varchar (255),
	@AdviseCategoryToFeeModelId bigint,
	@StampAction char(1)
AS

INSERT INTO TAdviseCategoryToFeeModelAudit 
( AdviseCategoryId, FeeModelId, ConcurrencyId, 
	AdviseCategoryToFeeModelId, StampAction, StampDateTime, StampUser) 
Select AdviseCategoryId, FeeModelId, ConcurrencyId, 
	AdviseCategoryToFeeModelId, @StampAction, GetDate(), @StampUser
FROM TAdviseCategoryToFeeModel
WHERE AdviseCategoryToFeeModelId = @AdviseCategoryToFeeModelId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
