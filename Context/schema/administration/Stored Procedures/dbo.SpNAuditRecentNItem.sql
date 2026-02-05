SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRecentNItem]
	@StampUser varchar (255),
	@RecentNItemId bigint,
	@StampAction char(1)
AS

INSERT INTO TRecentNItemAudit 
( RecentSearchAndReportId, RecentItemId, LastUpdated, ConcurrencyId, 
		
	RecentNItemId, StampAction, StampDateTime, StampUser) 
Select RecentSearchAndReportId, RecentItemId, LastUpdated, ConcurrencyId, 
		
	RecentNItemId, @StampAction, GetDate(), @StampUser
FROM TRecentNItem
WHERE RecentNItemId = @RecentNItemId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
