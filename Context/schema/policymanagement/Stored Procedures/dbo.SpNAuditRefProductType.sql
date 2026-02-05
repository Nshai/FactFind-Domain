SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefProductType]
	@StampUser varchar (255),
	@RefProductTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefProductTypeAudit 
( ProductTypeName, IntellifloCode, RefProductGroupId, RefPlanType2ProdSubTypeId, 
		IsArchived, ConcurrencyId, 
	RefProductTypeId, StampAction, StampDateTime, StampUser) 
Select ProductTypeName, IntellifloCode, RefProductGroupId, RefPlanType2ProdSubTypeId, 
		IsArchived, ConcurrencyId, 
	RefProductTypeId, @StampAction, GetDate(), @StampUser
FROM TRefProductType
WHERE RefProductTypeId = @RefProductTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
