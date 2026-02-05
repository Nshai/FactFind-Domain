SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[SpNioCustomCreateApplicationAccount]
	@UserName varchar(50),
	@Password varchar(50),
	--@ConcurrencyId bigint,
	@UserId bigint,
	@RefApplicationId bigint,
	@AdditionalReference varchar(50),
	@GroupName varchar(50),
	@Token varchar(max),
	@TokenExpiryDate datetime
As

Declare @ApplicationAccountId bigint 

exec dbo.SpNioCustomOpenSymmetricKeyForPasswordEncryption

Declare @EncryptedPassword varbinary(4000)
Select @EncryptedPassword = [dbo].[FnCustomEncryptPortalPassword] (@Password)
	
Insert Into TApplicationAccount
( RefApplicationId, UserId, UserName, AdditionalReference, ConcurrencyId, Password2,GroupName,Token, TokenExpiryDate)
Values( @RefApplicationId,  @UserId, @UserName, @AdditionalReference, 1, /* @ConcurrencyId, */ @EncryptedPassword,@GroupName, @Token, @TokenExpiryDate)

Select scope_identity()

GO
