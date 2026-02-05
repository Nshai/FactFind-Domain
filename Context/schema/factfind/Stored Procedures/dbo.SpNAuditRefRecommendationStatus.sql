SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditRefRecommendationStatus]
	@StampUser varchar (255),
	@RefRecommendationStatusId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefRecommendationStatusAudit 
( Identifier, ConcurrencyId, 
	RefRecommendationStatusId, StampAction, StampDateTime, StampUser) 
Select Identifier, ConcurrencyId, 
	RefRecommendationStatusId, @StampAction, GetDate(), @StampUser
FROM TRefRecommendationStatus
WHERE RefRecommendationStatusId = @RefRecommendationStatusId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
