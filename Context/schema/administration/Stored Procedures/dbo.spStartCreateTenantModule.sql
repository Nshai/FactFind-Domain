SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spStartCreateTenantModule] @NewTenantId bigint, @SourceTenantId bigint, @StepName sysname, @StepPayload nvarchar(max) = NULL 
as
begin
	set nocount on

	if @NewTenantId is null or @SourceTenantId is null or nullif(@StepName,'') is null begin
		raiserror('spStartCreateTenantModule cannot have null parameters', 16,1)
		return -1
	end

	if dbo.fnHasModuleBeenExecuted(@NewTenantId, @SourceTenantId, @StepName) = 1 return -1

	update dbo.TCreateTenantStep
	set StartedAt = GetDate(), 
		NumberOfExecutions+=1
	where SourceTenantId=@SourceTenantId 
		and NewTenantId=@NewTenantId 
		and StepName=@StepName

	if @@rowcount = 0
		insert into dbo.TCreateTenantStep(SourceTenantId, NewTenantId, StepName, StepPayload)
		select @SourceTenantId, @NewTenantId, @StepName, @StepPayload

	print 'Starting module: '+@StepName
	return 0
end
GO
