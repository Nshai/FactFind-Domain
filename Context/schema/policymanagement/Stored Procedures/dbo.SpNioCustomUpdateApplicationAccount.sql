SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[SpNioCustomUpdateApplicationAccount]
	@UserName varchar(50),
	@Password varchar(50),
	--@ConcurrencyId bigint,
	@UserId bigint,
	@RefApplicationId bigint,
	@AdditionalReference varchar(50),
	@GroupName varchar(50),
	@Token varchar(max),
	@TokenExpiryDate datetime,
	@Id bigint
As


exec dbo.SpNioCustomOpenSymmetricKeyForPasswordEncryption

Declare @EncryptedPassword varbinary(4000)
Select @EncryptedPassword = [dbo].[FnCustomEncryptPortalPassword] (@Password)


Update TApplicationAccount
Set RefApplicationId = @RefApplicationId, 
	UserId = @UserId, 
	UserName = @UserName, 
	-- ConcurrencyId = @ConcurrencyId, 
	Password2 = @EncryptedPassword,
	AdditionalReference = @AdditionalReference, 
	GroupName = @GroupName,
	Token = @Token,
	TokenExpiryDate = @TokenExpiryDate
Where ApplicationAccountId = @Id

Select @@Rowcount



GO
