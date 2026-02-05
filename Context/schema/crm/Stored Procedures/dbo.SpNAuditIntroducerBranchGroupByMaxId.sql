SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditIntroducerBranchGroupByMaxId]
	@StampUser varchar (255),
	@MaxId bigint,
	@StampAction char(1)
AS

INSERT INTO TIntroducerBranchGroupAudit 
( GroupId,ConcurrencyId,IntroducerBranchGroupId,
	StampAction, StampDateTime, StampUser) 
Select GroupId,ConcurrencyId,IntroducerBranchGroupId,
	@StampAction, GetDate(), @StampUser
FROM TIntroducerBranchGroup
WHERE IntroducerBranchGroupId > @MaxId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
