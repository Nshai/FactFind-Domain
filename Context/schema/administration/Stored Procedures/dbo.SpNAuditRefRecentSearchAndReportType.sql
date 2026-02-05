SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefRecentSearchAndReportType]
	@StampUser varchar (255),
	@RefRecentSearchAndReportTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefRecentSearchAndReportTypeAudit 
( Identifier, Archived, ConcurrencyId, 
	RefRecentSearchAndReportTypeId, StampAction, StampDateTime, StampUser) 
Select Identifier, Archived, ConcurrencyId, 
	RefRecentSearchAndReportTypeId, @StampAction, GetDate(), @StampUser
FROM TRefRecentSearchAndReportType
WHERE RefRecentSearchAndReportTypeId = @RefRecentSearchAndReportTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
