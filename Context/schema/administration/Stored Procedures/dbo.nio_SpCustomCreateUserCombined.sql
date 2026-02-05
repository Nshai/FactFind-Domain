SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_SpCustomCreateUserCombined]
	(
		@UserId bigint,
		@StampUser varchar(50)
	)

AS

begin

INSERT INTO Administration.dbo.TUserCombined (UserId, Identifier, IndigoClientId, IndigoClientGuid, Guid, UnipassSerialNbr, ConcurrencyId)
SELECT @UserId, u.Identifier, u.IndigoClientId, i.Guid, u.Guid, c.SerialNumber, 1
FROM Administration.dbo.TUser u
	JOIN Administration.dbo.TIndigoClient i on i.IndigoClientId = u.IndigoClientId
	LEFT JOIN Administration.dbo.TCertificate c ON c.UserId = u.UserId
WHERE u.UserId = @UserId

INSERT INTO Administration.dbo.TUserCombinedAudit (UserId, Identifier, IndigoClientId, IndigoClientGuid, UnipassSerialNbr, ConcurrencyId, Guid, StampAction, StampUser, StampDateTime)
SELECT UserId, Identifier, IndigoClientId, IndigoClientGuid, UnipassSerialNbr, 1, Guid, 'C', @StampUser, getdate()
	FROM Administration.dbo.TUserCombined WHERE UserId = @UserId

SELECT 1

end
GO
