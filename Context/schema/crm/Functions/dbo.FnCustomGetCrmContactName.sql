SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnCustomGetCrmContactName]
	(@CrmContactId as BIGINT)
	RETURNS Varchar(255)
AS
BEGIN
	Declare @ReturnValue varchar(255)

	Select @ReturnValue = RTrim(LTrim(IsNull(FirstName, '') + ' ' + IsNull(LastName, '')))
		 + IsNull(CorporateName, '') 
	From dbo.TCrmContact
	Where CrmContactId = @CrmContactId
	
	RETURN @ReturnValue
END
GO
