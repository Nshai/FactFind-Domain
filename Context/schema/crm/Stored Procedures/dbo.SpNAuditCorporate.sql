SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditCorporate]
    @StampUser varchar (255),
    @CorporateId bigint,
    @StampAction char(1)
AS

INSERT INTO TCorporateAudit 
(
     IndClientId
    ,CorporateName
    ,ArchiveFg
    ,BusinessType
    ,RefCorporateTypeId
    ,CompanyRegNo
    ,EstIncorpDate
    ,YearEnd
    ,VatRegFg
    ,VatRegNo
    ,ConcurrencyId
    ,CorporateId
    ,StampAction
    ,StampDateTime
    ,StampUser
    ,[LEI]
    ,[LEIExpiryDate]
    ,[BusinessRegistrationNumber]
    ,[NINumber]
) 
Select 
     IndClientId
    , CorporateName
    , ArchiveFg
    , BusinessType
    , RefCorporateTypeId
    , CompanyRegNo
    , EstIncorpDate
    , YearEnd
    , VatRegFg
    , VatRegNo
    , ConcurrencyId
    , CorporateId
    , @StampAction
    , GetDate()
    , @StampUser
    , [LEI]
    , [LEIExpiryDate]
    , [BusinessRegistrationNumber]
    , [NINumber]
FROM TCorporate
WHERE CorporateId = @CorporateId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
