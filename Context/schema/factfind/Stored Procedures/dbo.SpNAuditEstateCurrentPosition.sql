SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditEstateCurrentPosition]
	@StampUser varchar (255),
	@EstateCurrentPositionId bigint,
	@StampAction char(1)
AS

INSERT INTO TEstateCurrentPositionAudit 
( CRMContactId, BroadContent, client1total, client2total, 
		jointtotal, CapitalGifts, UsedAnnualExemption, RegularGifts, 
		ConcurrencyId, EstimatedLiabilities,Inheritance,
	EstateCurrentPositionId, StampAction, StampDateTime, StampUser,EstimatedLiabilitiesJoint) 
Select CRMContactId, BroadContent, client1total, client2total, 
		jointtotal, CapitalGifts, UsedAnnualExemption, RegularGifts, 
		ConcurrencyId, EstimatedLiabilities,Inheritance,
	EstateCurrentPositionId, @StampAction, GetDate(), @StampUser,EstimatedLiabilitiesJoint
FROM TEstateCurrentPosition
WHERE EstateCurrentPositionId = @EstateCurrentPositionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
