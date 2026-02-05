
Create PROCEDURE [dbo].[SpNAuditProtectionNeedAnalysisItem]
	@StampUser varchar (255),
	@ProtectionNeedAnalysisItemId int,
	@StampAction char(1)
AS

INSERT INTO TProtectionNeedAnalysisItemAudit 
( TenantId, CreatedDateTime, CreatedByUserId, LastUpdateDateTime, 
		LastUpdateByUserId, ProtectionSessionId, Description, Notes, 
		ClientId, JointClientId, NeedAnalysisType, NeedOrder, NeedOrderForJointParty,
		Outcome, HasSufficientDetail, HasSufficientCover, CoverAmount, CoverType, Term, 
		TermType, 
	ProtectionNeedAnalysisItemId, StampAction, StampDateTime, StampUser) 
Select TenantId, CreatedDateTime, CreatedByUserId, LastUpdateDateTime, 
		LastUpdateByUserId, ProtectionSessionId, Description, Notes, 
		ClientId, JointClientId, NeedAnalysisType, NeedOrder, NeedOrderForJointParty,
		Outcome, HasSufficientDetail, HasSufficientCover, CoverAmount, CoverType, Term, 
		TermType, 
	ProtectionNeedAnalysisItemId, @StampAction, GetDate(), @StampUser
FROM TProtectionNeedAnalysisItem
WHERE ProtectionNeedAnalysisItemId = @ProtectionNeedAnalysisItemId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

