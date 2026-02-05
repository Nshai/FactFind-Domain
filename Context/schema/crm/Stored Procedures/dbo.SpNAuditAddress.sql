SET QUOTED_IDENTIFIER OFF
GO

SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditAddress]
	@StampUser VARCHAR(255),
	@AddressId BIGINT,
	@StampAction CHAR(1)
AS
INSERT INTO TAddressAudit (
	IndClientId,
	CRMContactId,
	AddressStoreId,
	RefAddressTypeId,
	AddressTypeName,
	DefaultFg,
	RefAddressStatusId,
	ResidentFromDate,
	ResidentToDate,
	ConcurrencyId,
	IsRegisteredOnElectoralRoll,
	AddressId,
	Extensible,
	ResidencyStatus,
	PropertyStatus,
	TenureType,
	IsPotentialMortgage,
  	CreatedOn,
  	CreatedByUserId,
  	UpdatedOn,
  	UpdatedByUserId,
	StampAction,
	StampDateTime,
	StampUser
	)
SELECT IndClientId,
	CRMContactId,
	AddressStoreId,
	RefAddressTypeId,
	AddressTypeName,
	DefaultFg,
	RefAddressStatusId,
	ResidentFromDate,
	ResidentToDate,
	ConcurrencyId,
	IsRegisteredOnElectoralRoll,
	AddressId,
	Extensible,
	ResidencyStatus,
	PropertyStatus,
	TenureType,
	IsPotentialMortgage,
  	CreatedOn,
  	CreatedByUserId,
  	UpdatedOn,
  	UpdatedByUserId,
	@StampAction,
	GetDate(),
	@StampUser
FROM TAddress
WHERE AddressId = @AddressId

IF @@ERROR != 0
	GOTO errh

RETURN (0)

errh:

RETURN (100)
GO


