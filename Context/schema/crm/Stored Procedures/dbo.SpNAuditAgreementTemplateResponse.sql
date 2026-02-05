SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAgreementTemplateResponse]
    @StampUser varchar (255),
    @AgreementTemplateResponseId int,
    @StampAction char(1)
AS

INSERT INTO TAgreementTemplateResponseAudit
    (
    AgreementTemplateResponseId
    ,AgreementTemplateId
    ,Text
    ,Ordinal
    ,CreatedOn
    ,CreatedBy
    ,UpdatedOn
    ,UpdatedBy
    ,StampAction
    ,StampDateTime
    ,StampUser
    )
Select
    AgreementTemplateResponseId
    , AgreementTemplateId
    , Text
    , Ordinal
    , CreatedOn
    , CreatedBy
    , UpdatedOn
    , UpdatedBy
    , @StampAction
    , GetDate()
    , @StampUser
FROM TAgreementTemplateResponse
WHERE AgreementTemplateResponseId = @AgreementTemplateResponseId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)