SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrievePractitionersSIB]  @CRMContactId bigint
AS


Declare @IndigoClientId bigint
Select @IndigoClientId = IndigoClientId From Administration..TUser Where CRMContactId = @CRMContactId

Select A.CRMContactId, UserId = B.UserId, C.IndigoClientId, SIB = 
Case When IsNull(C.SIB,'') <> '' Then IsNull(C.SIB,'') Else IsNull(D.SIB,'') End
From CRM..TPractitioner A
Inner Join Administration..TUser B On A.CRMContactId = B.CRMContactId
Inner Join Administration..TIndigoClient C 
	--On B.GroupId = C.PrimaryGroupId
	On B.IndigoClientId = C.IndigoClientId
Left Join 
(Select top 1 IndigoClientId, GroupId, SIB 
From Administration..TIndigoClientSIB
Where IndigoClientId = @IndigoClientId)
 D On D.GroupId = B.GroupId
Where A.CRMContactId = @CRMContactId
GO
