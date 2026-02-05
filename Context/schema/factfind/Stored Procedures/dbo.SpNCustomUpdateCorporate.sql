SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpNCustomUpdateCorporate] 
@ConcurrencyId bigint,
@BusinessType varchar(2000),
@CorporateId bigint,
@CRMContactId bigint,
@StampUser varchar(50)

as

begin


INSERT INTO CRM.dbo.TCorporateAudit (IndClientId, CorporateName, ArchiveFG, BusinessType, RefCorporateTypeId, CompanyRegNo, EstIncorpDate, YearEnd, VatRegFg, Extensible, VatRegNo, ConcurrencyId, CorporateId, StampAction, StampDateTime, StampUser)
SELECT IndClientId, CorporateName, ArchiveFG, BusinessType, RefCorporateTypeId, CompanyRegNo, EstIncorpDate, YearEnd, VatRegFg, Extensible, VatRegNo, ConcurrencyId, CorporateId, 'U', getdate(), @StampUser
FROM CRM.dbo.TCorporate WHERE CorporateId = @CorporateId

UPDATE CRM.dbo.TCorporate
SET BusinessType = @BusinessType
WHERE CorporateId = @CorporateId

end
GO
