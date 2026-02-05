SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:        Olga Tikhonova
-- Create date:   21/11/2022
-- Description:   Stored procedure to retrieve corporate client details by CRMContactId
-- Updated: 10/01/2023 by Andrei Piliuhin, to get clients where type is null as Unknown
-- =============================================
CREATE PROCEDURE dbo.spGetCorporateClientById
    @TenantId INT,
    @CRMContactId INT
AS
BEGIN
    SELECT corporate.CorporateId,
      corporate.IndClientId,
      corporate.CorporateName AS Name,
      corporate.BusinessType,
      corporateType.TypeName AS [Type],
      corporate.CompanyRegNo AS CompanyRegistrationNumber,
      corporate.EstIncorpDate AS  EstablishedOrIncorporatedOn,
      corporate.YearEnd AS TaxYearEnd,
      corporate.VatRegFg AS IsVatRegistered,
      corporate.LEI AS LegalEntityIdentifier,
      corporate.LEIExpiryDate,
      corporate.VatRegNo AS VatRegistrationNumber,
      corporate.NINumber
  FROM crm..TCRMContact contact
  JOIN crm..TCorporate corporate ON contact.CorporateId = corporate.CorporateId
  LEFT JOIN crm..TRefCorporateType corporateType ON corporate.RefCorporateTypeId = corporateType.RefCorporateTypeId
  WHERE corporate.IndClientId = @TenantId AND contact.CRMContactId = @CRMContactId
END
