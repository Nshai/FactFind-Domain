SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
USE CRM
GO
CREATE procedure SpNCustomUpdateGcdId
@CRMContactId bigint,
@GcdId varchar(50) 
  
as  
  
begin  
  
	declare @CRMContactExtId bigint  

	-- make sure the client exists
	IF NOT EXISTS (SELECT 1 FROM TCRMContact WHERE CRMContactId = @CRMContactId)
	begin
		print 'CRMContactId ' + cast(@CRMContactId as varchar(10)) + ' not found'
		return
	end
	  
	-- make sure there is a crmcontactext record to update
	set @CRMContactExtId = (select CRMContactExtId FROM TCRMContactExt WHERE CRMContactId = @CRMContactId)  

	IF @CRMContactExtId IS NULL
	begin
		print 'Cannot find CRMContactExt record for CRMContactId ' + cast(@CRMContactId as varchar(10))
		return
	end

	-- all ok, proceed with update
	exec SpNAuditCRMContactExt '0', @CRMContactExtId, 'U'  

	update TCRMContactExt set externalid=@GcdId, ExternalSystem='Gcd' WHERE CRMContactId = @CRMContactId

end

