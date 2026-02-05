SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefIntroducerType]
	@StampUser varchar (255),
	@RefIntroducerTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefIntroducerTypeAudit 
( IndClientId, ShortName, LongName, MinSplitRange, 
		MaxSplitRange, DefaultSplit, RenewalsFG, ArchiveFG, 
		ConcurrencyId, 
	RefIntroducerTypeId, StampAction, StampDateTime, StampUser) 
Select IndClientId, ShortName, LongName, MinSplitRange, 
		MaxSplitRange, DefaultSplit, RenewalsFG, ArchiveFG, 
		ConcurrencyId, 
	RefIntroducerTypeId, @StampAction, GetDate(), @StampUser
FROM TRefIntroducerType
WHERE RefIntroducerTypeId = @RefIntroducerTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
