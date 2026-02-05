SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNioClientBankAccountByCRMContactId]
	 @CRMContactId BIGINT,
	 @IndigoClientId BIGINT,
       @CRMContactId2 BIGINT = 0
AS

SELECT
       [CRMContactId]
      ,[CRMContactId2]
      ,[BankName]
      ,[AddressLine1]
      ,[AddressLine2]
      ,[AddressLine3]
      ,[AddressLine4]
      ,[CityTown]
      ,[RefCountyId]
      ,[RefCountryId]
      ,[PostCode]
      ,[SortCode]
      ,[AccountHolders]
      ,[AccountNumber]
      ,[AccountName]
      ,[DefaultAccountFg]
FROM crm..TClientBankAccount cba
WHERE cba.IndigoClientId = @IndigoClientId
AND (cba.CRMContactId = @CRMContactId
      OR (@CRMContactId2 > 0 AND cba.CRMContactId = @CRMContactId2))