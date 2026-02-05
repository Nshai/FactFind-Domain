SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[nio_UniPassCertificate_CustomUpdateUserCombined] @StampUser bigint, @UserId bigint, @TenantId bigint, @UnipassSerialNumber varchar(255)
as

Declare @StampAction char

if @UnipassSerialNumber = ''
	Select @UnipassSerialNumber = null, @StampAction = 'D'
else
	Set @StampAction = 'U'


INSERT INTO TUserCombinedAudit (Guid, UserId, Identifier, IndigoClientId, IndigoClientGuid, UnipassSerialNbr, ConcurrencyId, StampAction, StampUser, StampDateTime)        
SELECT Guid, UserId, Identifier, IndigoClientId, IndigoClientGuid, UnipassSerialNbr, ConcurrencyId, @StampAction, @StampUser, getdate()        
FROM TUserCombined WHERE UserId = @UserId and IndigoClientId = @TenantId


Update TUserCombined
Set UnipassSerialNbr = @UnipassSerialNumber
Where UserId = @UserId and IndigoClientId = @TenantId
GO
