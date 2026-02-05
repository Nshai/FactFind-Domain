SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_SpCustomDeleteUserCombinedForEmail]
@UserId bigint,
@StampUser varchar(50)

AS
begin

INSERT INTO Administration.dbo.TUserCombinedAudit (UserId, Identifier, IndigoClientId, IndigoClientGuid, UnipassSerialNbr, ConcurrencyId, Guid, StampAction, StampUser, StampDateTime)
SELECT UserId, Identifier, IndigoClientId, IndigoClientGuid, UnipassSerialNbr, 1, Guid, 'D', @StampUser, getdate()
	FROM Administration.dbo.TUserCombined WHERE UserId = @UserId

Delete TUserCombined where UserId = @UserId

end
GO
