SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[SpCustomDashboardRetrieveMyAccessDiary]  
@UserId bigint  
  
as  
  
begin  
	 select distinct c.CRMContactId as CRMContactId
	 ,c.FirstName +' ' + c.LastName as UserName
	 from crm..TDiaryPermission as d
	 Inner Join administration..TUser as u
	 On (d.OwnerUserId = u.UserId)
	 Inner Join crm..TCRMContact as c
	 On (u.CRMContactId = c.CRMContactId)
	 Inner Join crm..TPractitioner as t
	 On (t.CRMContactId = c.CRMContactId)
	 Where d.PermittedUserId  =  @UserId
	 And t.AuthorisedFG = 1
	 
  
END  
  
  
  
  

GO
