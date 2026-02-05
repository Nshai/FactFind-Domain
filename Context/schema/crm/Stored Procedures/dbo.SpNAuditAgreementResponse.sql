SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAgreementResponse]
    @StampUser varchar (255),
    @AgreementResponseId int,
    @StampAction char(1)
AS

INSERT INTO TAgreementResponseAudit
    (
    AgreementResponseId
    ,AgreementId
    ,Text
    ,Ordinal
    ,IsSelected
    ,CreatedOn
    ,CreatedBy
    ,UpdatedOn
    ,UpdatedBy
    ,StampAction
    ,StampDateTime
    ,StampUser
    )
Select
    AgreementResponseId
    , AgreementId
    , Text
    , Ordinal
    , IsSelected
    , CreatedOn
    , CreatedBy
    , UpdatedOn
    , UpdatedBy
    , @StampAction
    , GetDate()
    , @StampUser
FROM TAgreementResponse
WHERE AgreementResponseId = @AgreementResponseId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)