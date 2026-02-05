SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAgreementTemplate]
    @StampUser varchar (255),
    @AgreementTemplateId int,
    @StampAction char(1)
AS

INSERT INTO TAgreementTemplateAudit
    (
    AgreementTemplateId
    ,Name
    ,Description
    ,Statement
    ,IsArchived
    ,GroupId
    ,GroupName
    ,IncludeSubgroups
    ,TenantId
    ,CreatedOn
    ,CreatedBy
    ,UpdatedOn
    ,UpdatedBy
    ,[Version]
    ,[BaseTemplateId]
    ,StampAction
    ,StampDateTime
    ,StampUser
    )
Select
    AgreementTemplateId
    , Name
    , Description
    , Statement
    , IsArchived
    , GroupId
    , GroupName
    , IncludeSubgroups
    , TenantId
    , CreatedOn
    , CreatedBy
    , UpdatedOn
    , UpdatedBy
    , [Version]
    , [BaseTemplateId]
    , @StampAction
    , GetDate()
    , @StampUser
FROM TAgreementTemplate
WHERE AgreementTemplateId = @AgreementTemplateId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)