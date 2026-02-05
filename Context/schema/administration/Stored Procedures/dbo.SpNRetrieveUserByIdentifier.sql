SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveUserByIdentifier]
	@Identifier varchar (64)
AS

Select * 
From Administration.dbo.TUser As [User]
Where [User].Identifier = @Identifier
GO
