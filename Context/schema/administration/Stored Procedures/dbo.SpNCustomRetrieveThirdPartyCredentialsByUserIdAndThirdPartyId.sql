SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
create PROCEDURE [dbo].[SpNCustomRetrieveThirdPartyCredentialsByUserIdAndThirdPartyId]
@UserId int,
@ThirdPartyId int
AS

SELECT 
ISNULL(T1.UserId, '') AS UserId, 
ISNULL(T2.ThirdPartyDescription, '') AS ThirdPartyDescription,
ISNULL(T1.UserDescription, '') AS UserDescription, 
ISNULL(T1.UserName, '') AS UserName, 
ISNULL(T1.Password, '') AS Password
FROM TThirdPartyCredentials T1
inner join TThirdParty T2 on T1.ThirdPartyId = T2.ThirdPartyId
WHERE (T1.UserId = @UserId) and T1.ThirdPartyId = @ThirdPartyId

GO
