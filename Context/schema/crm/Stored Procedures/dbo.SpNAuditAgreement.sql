SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAgreement]
    @StampUser varchar (255),
    @AgreementId int,
    @StampAction char(1)
AS

INSERT INTO TAgreementAudit
    (
    AgreementId
    ,AgreementTemplateId
    ,CrmContactId
    ,Statement
    ,Status
    ,CreatedAt
    ,CompletedAt
    ,ExpiresOn
    ,TenantId
    ,CreatedOn
    ,CreatedBy
    ,UpdatedOn
    ,UpdatedBy
    ,StampAction
    ,StampDateTime
    ,StampUser
    )
Select
    AgreementId
    , AgreementTemplateId
    , CrmContactId
    , Statement
    , Status
    , CreatedAt
    , CompletedAt
    , ExpiresOn
    , TenantId
    , CreatedOn
    , CreatedBy
    , UpdatedOn
    , UpdatedBy
    , @StampAction
    , GetDate()
    , @StampUser
FROM TAgreement
WHERE AgreementId = @AgreementId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)