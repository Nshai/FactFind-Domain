SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAssetModelProcessSummary]
	@StampUser varchar (255),
	@AssetModelProcessSummaryId int,
	@StampAction char(1)
AS


INSERT INTO TAssetModelProcessSummaryAudit 
( TenantId, AtrTemplateId, RefPortfolioTypeId, DocVersionId, ProcessStatus, ConcurrencyId,
	AssetModelProcessSummaryId, StampAction, StampDateTime, StampUser)

Select TenantId, AtrTemplateId, RefPortfolioTypeId, DocVersionId, ProcessStatus, ConcurrencyId,
	AssetModelProcessSummaryId, @StampAction, GetDate(), @StampUser
FROM TAssetModelProcessSummary
WHERE AssetModelProcessSummaryId = @AssetModelProcessSummaryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO