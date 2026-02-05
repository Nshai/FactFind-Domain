SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveClientAdviserDetails]
	@CRMContactId Bigint, @UserId Bigint
AS


--Declare @CRMContactId bigint, @UserId bigint
--Set @CRMContactId = 60047
--Set @UserId = 134

Declare @LoggedInUserCRMId bigint, @LoggedInUserName varchar(255)

Select @LoggedInUserCRMId = T1.CRMContactId, @LoggedInUserName = T2.FirstName + ' ' + T2.LastName
From Administration..TUser T1
Inner Join CRM..TCRMContact T2 On T1.CRMContactId = T2.CRMContactId
Where T1.UserId = @UserId


Select 
	1 As Tag,
	Null As Parent,

	NULL As [ClientAdviserDetails!1!], --Root Tag

	Null As [ClientAdviserDetail!2!ClientCRMContactId],
	Null As [ClientAdviserDetail!2!ServicingAdviserCRMId],
	Null As [ClientAdviserDetail!2!ServicingAdviserName],
	Null As [ClientAdviserDetail!2!LoggedInUserCRMId],
	Null As [ClientAdviserDetail!2!LoggedInUserName]

Union All

Select 
	2 As Tag,
	1 As Parent,

	NULL, --Root Tag

	T1.CRMContactId As [ClientAdviserDetail!2!ClientCRMContactId],
	T1.CurrentAdviserCRMId As [ClientAdviserDetail!2!ServicingAdviserCRMId],
	T2.FirstName + ' ' + T2.LastName As [ClientAdviserDetail!2!ServicingAdviserName],
	@LoggedInUserCRMId As [ClientAdviserDetail!2!LoggedInUserCRMId],
	IsNull(@LoggedInUserName,'') As [ClientAdviserDetail!2!LoggedInUserName]

From CRM..TCRMContact T1
Inner Join CRM..TCRMContact T2 On T1.CurrentAdviserCRMId = T2.CRMContactId
Where T1.CRMContactId = @CRMContactId

Order By [ClientAdviserDetail!2!ClientCRMContactId]
For XML Explicit
GO
