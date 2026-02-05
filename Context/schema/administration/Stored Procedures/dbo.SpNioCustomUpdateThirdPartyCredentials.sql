SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- drop Procedure SpNioCustomUpdateThirdPartyCredentials
Create Procedure [dbo].[SpNioCustomUpdateThirdPartyCredentials]
@UserDescription varchar(50), 
@UserName varchar(255), 
@Password varchar(50), 
@ConcurrencyId int, 
@UserId int, 
@ThirdPartyId int,
@Id bigint

As

exec dbo.SpNioCustomOpenSymmetricKeyForPasswordEncryption

Declare @EncryptedPassword varbinary(4000)
Select @EncryptedPassword = [dbo].[FnCustomEncryptPortalPassword] (@Password)

Update Administration.dbo.[TThirdPartyCredentials] 
Set UserDescription =@UserDescription,
	UserName = @UserName,
	Password2 = @EncryptedPassword,
	ConcurrencyId = @ConcurrencyId,
	UserId = @UserId, 
	ThirdPartyId = @ThirdPartyId
Where ThirdPartyCredentialsId = @Id

select @@RowCount
GO
