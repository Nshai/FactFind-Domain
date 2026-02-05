SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--sp_helptext SpDBSetupCreateRefProdProviderLicenseType 2183, 'Full'

CREATE procedure [dbo].[SpDBSetupCreateRefProdProviderLicenseType]
@RefProdProviderId bigint,
@LicenseType varchar(255)

as

begin

	declare @RefLicenseTypeId bigint

	set @RefLicenseTypeId = (select RefLicenseTypeId FROM Administration..TRefLicenseType WHERE LicenseTypeName = @LicenseType AND RefLicenseStatusId = 1)

	IF @RefLicenseTypeId IS NULL
	BEGIN
		print 'Cannot find license type ' + @LicenseType
		return
	END

	INSERT INTO TRefLicenseTypeToRefProdProvider (RefLicenseTypeId, RefProdproviderId)
	SELECT @RefLicenseTypeId, @RefProdProviderId

	INSERT INTO TRefLicenseTypeToRefProdProviderAudit (RefLicenseTypeId, RefProdproviderId, ConcurrencyId, RefLicenseTypeToRefProdProviderId,
		StampAction, StampDateTime, StampUser)
	SELECT RefLicenseTypeId, RefProdproviderId, ConcurrencyId, RefLicenseTypeToRefProdProviderId,
		'C', getdate(), '0'
	FROM TRefLicenseTypeToRefProdProvider
	WHERE RefLicenseTypeId = @RefLicenseTypeId 
	AND RefProdProviderId = @RefProdProviderId

end


GO
