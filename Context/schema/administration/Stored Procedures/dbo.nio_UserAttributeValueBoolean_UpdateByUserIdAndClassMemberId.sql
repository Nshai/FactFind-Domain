SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Procedure [dbo].[nio_UserAttributeValueBoolean_UpdateByUserIdAndClassMemberId]
	@UserId bigint 
	, @ClassMemberId varchar(50) ,
	@AttributeValue bit,
	@StampUser bigint  

AS

Insert Into TUserAttributeValueBooleanAudit
(UserId, ClassMemberId, AttributeValue, ConcurrencyId, UserAttributeValueBooleanId, 
	StampAction, StampDateTime, StampUser )
Select UserId, ClassMemberId, AttributeValue, ConcurrencyId, UserAttributeValueBooleanId,
	'U', GetDate(), @StampUser
From TUserAttributeValueBoolean
-- Where UserAttributeValueBooleanId = @UserAttributeValueBooleanId
Where UserId = @UserId And ClassMemberId = @ClassMemberId
			
Update A
Set A.AttributeValue = @AttributeValue,
	A.ConcurrencyId = A.ConcurrencyId + 1
From TUserAttributeValueBoolean As A
-- Where UserAttributeValueBooleanId = @UserAttributeValueBooleanId
Where UserId = @UserId And ClassMemberId = @ClassMemberId
GO
