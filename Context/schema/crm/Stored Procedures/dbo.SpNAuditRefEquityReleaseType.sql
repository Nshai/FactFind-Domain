SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefEquityReleaseType]
	@StampUser varchar (255),
	@RefEquityReleaseTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefEquityReleaseTypeAudit 
			(	EquityReleaseType, 
				ConcurrencyId, 
				RefEquityReleaseTypeId, 
				StampAction, 
				StampDateTime, 
				StampUser) 
SELECT EquityReleaseType, 
	   ConcurrencyId, 
	   RefEquityReleaseTypeId, 
	   @StampAction, 
	   GetDate(), 
	   @StampUser
FROM  crm..TRefEquityReleaseType
WHERE RefEquityReleaseTypeId = @RefEquityReleaseTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
