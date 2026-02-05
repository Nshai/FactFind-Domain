SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAliasRetrieveUserBasic]
	@UserId bigint
AS

Select * 
From Administration.dbo.TUser As [User]
Inner Join Administration.dbo.TGroup As [Group]
	On [User].GroupId = [Group].GroupId
Inner Join CRM.dbo.TCRMContact As [CRMContact]
	On [User].CRMContactId = [CRMContact].CRMContactId
Where [User].UserId = @UserId
GO
