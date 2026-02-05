
-- drop Procedure SpNioCustomCreateThirdPartyCredentials
Create Procedure SpNioCustomCreateThirdPartyCredentials
@UserDescription varchar(50), 
@UserName varchar(255), 
@Password varchar(50), 
@ConcurrencyId int, 
@UserId int, 
@ThirdPartyId int

As

-- SpNioCustomCreateThirdPartyCredentials @UserDescription = 'fff', @UserName ='ggg', @Password ='qwe', @ConcurrencyId =1, @UserId=22, @ThirdPartyId=44
-- select * From TThirdPartyCredentials


exec dbo.SpNioCustomOpenSymmetricKeyForPasswordEncryption

Declare @EncryptedPassword varbinary(4000)
Select @EncryptedPassword = [dbo].[FnCustomEncryptPortalPassword] (@Password)

INSERT INTO Administration.dbo.[TThirdPartyCredentials] 
(UserDescription, UserName, Password2, ConcurrencyId, UserId, ThirdPartyId) 
VALUES (@UserDescription, @UserName, @EncryptedPassword, @ConcurrencyId, @UserId, @ThirdPartyId)


select SCOPE_IDENTITY()