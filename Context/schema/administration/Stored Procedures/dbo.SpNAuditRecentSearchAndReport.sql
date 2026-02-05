SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRecentSearchAndReport]
	@StampUser varchar (255),
	@RecentSearchAndReportId bigint,
	@StampAction char(1)
AS

INSERT INTO TRecentSearchAndReportAudit 
( UserId, Controller, Action, URL, 
		LastUpdated, RefRecentSearchAndReportTypeId, ConcurrencyId, 
	RecentSearchAndReportId, StampAction, StampDateTime, StampUser) 
Select UserId, Controller, Action, URL, 
		LastUpdated, RefRecentSearchAndReportTypeId, ConcurrencyId, 
	RecentSearchAndReportId, @StampAction, GetDate(), @StampUser
FROM TRecentSearchAndReport
WHERE RecentSearchAndReportId = @RecentSearchAndReportId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
