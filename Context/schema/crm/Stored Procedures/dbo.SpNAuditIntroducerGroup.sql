SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditIntroducerGroup]
	@StampUser varchar (255),
	@IntroducerGroupId bigint,
	@StampAction char(1)
AS

INSERT INTO TIntroducerGroupAudit 
( IntroducerId, GroupId, ConcurrencyId, 
	IntroducerGroupId, StampAction, StampDateTime, StampUser) 
Select IntroducerId, GroupId, ConcurrencyId, 
	IntroducerGroupId, @StampAction, GetDate(), @StampUser
FROM TIntroducerGroup
WHERE IntroducerGroupId = @IntroducerGroupId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
