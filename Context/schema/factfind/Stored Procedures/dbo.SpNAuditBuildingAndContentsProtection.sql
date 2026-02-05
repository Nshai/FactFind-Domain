SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditBuildingAndContentsProtection]
	@StampUser varchar (255),
	@BuildingAndContentsProtectionId bigint,
	@StampAction char(1)
AS

INSERT INTO TBuildingAndContentsProtectionAudit 
(ConcurrencyId, CRMContactId, IsCoverSufficient, AnyBuyToLet, IsBtlCoverSufficient, HowToAddress, 
	WhenToReview, NotReviewingReason, AnyExistingProvision,
	BuildingAndContentsProtectionId, StampAction, StampDateTime, StampUser,
	AnyExistingBuildingProvision, AnyExistingContentsProvision)
SELECT  ConcurrencyId, CRMContactId, IsCoverSufficient, AnyBuyToLet, IsBtlCoverSufficient, HowToAddress, 
	WhenToReview, NotReviewingReason, AnyExistingProvision,
	BuildingAndContentsProtectionId, @StampAction, GetDate(), @StampUser,
	AnyExistingBuildingProvision, AnyExistingContentsProvision
FROM TBuildingAndContentsProtection
WHERE BuildingAndContentsProtectionId = @BuildingAndContentsProtectionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
