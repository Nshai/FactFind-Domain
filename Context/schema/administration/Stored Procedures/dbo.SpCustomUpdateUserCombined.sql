SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpCustomUpdateUserCombined]      
@UserId bigint,   
@RefEnvironmentId bigint,     
@StampUser varchar(50)      
      
as      
      
begin      
      
INSERT INTO TUserCombinedAudit (Guid, UserId, Identifier, IndigoClientId, IndigoClientGuid, UnipassSerialNbr, ConcurrencyId, StampAction, StampUser, StampDateTime)      
SELECT Guid, UserId, Identifier, IndigoClientId, IndigoClientGuid, UnipassSerialNbr, ConcurrencyId, 'U', @StampUser, getdate()      
FROM TUserCombined WHERE UserId = @UserId      
      
UPDATE uc      
SET Identifier = u.Identifier
FROM TUserCombined uc    
JOIN TIndigoClientCombined icc ON uc.IndigoClientGuid = icc.Guid    
JOIN TUser u ON u.UserId = uc.UserId
WHERE uc.UserId = @UserId      
and icc.RefEnvironmentId = @RefEnvironmentId    
      
UPDATE uc      
SET uc.UnipassSerialNbr = c.SerialNumber      
FROM TUserCombined uc      
JOIN TIndigoClientCombined icc ON uc.IndigoClientGuid = icc.Guid    
LEFT JOIN TCertificate c ON c.UserId = uc.UserId      
WHERE uc.UserId = @UserId      
AND icc.RefEnvironmentId = @RefEnvironmentId    
      
SELECT * FROM TUserCombined WHERE UserId = @UserId FOR XML AUTO      
end
GO
