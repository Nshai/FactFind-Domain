SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefPlanType2ProdSubType]
	@StampUser varchar (255),
	@RefPlanType2ProdSubTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefPlanType2ProdSubTypeAudit 
( RefPlanTypeId, ProdSubTypeId, RefPortfolioCategoryId, RefPlanDiscriminatorId, DefaultCategory, ConcurrencyId, 
		
	RefPlanType2ProdSubTypeId, StampAction, StampDateTime, StampUser, IsArchived, IsConsumerFriendly) 
Select RefPlanTypeId, ProdSubTypeId, RefPortfolioCategoryId, RefPlanDiscriminatorId, DefaultCategory, ConcurrencyId, 
		
	RefPlanType2ProdSubTypeId, @StampAction, GetDate(), @StampUser, IsArchived, IsConsumerFriendly
FROM TRefPlanType2ProdSubType
WHERE RefPlanType2ProdSubTypeId = @RefPlanType2ProdSubTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
