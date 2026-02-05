SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditRefIncreaseRate]
	@StampUser varchar (255),
	@RefIncreaseRateId int,
	@StampAction char(1)
AS

INSERT INTO TRefIncreaseRateAudit 
( IncreaseRateType, Ordinal, ConcurrencyId, 
	RefIncreaseRateId, StampAction, StampDateTime, StampUser) 
Select IncreaseRateType, Ordinal, ConcurrencyId, 
	RefIncreaseRateId, @StampAction, GetDate(), @StampUser
FROM TRefIncreaseRate
WHERE RefIncreaseRateId = @RefIncreaseRateId
GO
