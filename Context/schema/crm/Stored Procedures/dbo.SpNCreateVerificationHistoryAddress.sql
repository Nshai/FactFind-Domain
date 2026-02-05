SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpNCreateVerificationHistoryAddress]
@StampUser varchar(255),
@UserId bigint,
@CRMContactId bigint,
@AddressId bigint,
@LookupDate datetime,
@LookupResult bit

as

declare @VerificationHistoryAddressId bigint

insert into TVerificationHistoryAddress
(UserId,
CRMContactId,
AddressId,
LookupDate,
LookupResult,
ConcurrencyId)
select
@UserId,
@CRMContactId,
@AddressId,
@LookupDate,
@LookupResult,
1

select @VerificationHistoryAddressId = SCOPE_IDENTITY()

exec SpNAuditVerificationHistoryAddress @StampUser, @VerificationHistoryAddressId, 'C'

select	VerificationHistoryAddressId,
		CRMContactId,
		UserId,
		AddressId,
		LookupDate,
		LookupResult,
		ConcurrencyId
from	TVerificationHistoryAddress
where	VerificationHistoryAddressId = @VerificationHistoryAddressId
GO
