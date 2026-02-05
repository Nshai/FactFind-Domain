SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditIntroducerBranch]
	@StampUser varchar (255),
	@IntroducerBranchId bigint,
	@StampAction char(1)
AS

INSERT INTO TIntroducerBranchAudit
(
	IntroducerId, BranchName, IsArchived, ConcurrencyId, IntroducerBranchId, 
	StampAction, StampDateTime, StampUser
)

SELECT 
	IntroducerId, BranchName, IsArchived, ConcurrencyId, IntroducerBranchId, 
	@StampAction, GetDate(),  @StampUser
FROM TIntroducerBranch
WHERE IntroducerBranchId = @IntroducerBranchId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
