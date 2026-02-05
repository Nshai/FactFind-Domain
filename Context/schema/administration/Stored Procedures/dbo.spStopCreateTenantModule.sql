SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spStopCreateTenantModule] @NewTenantId bigint, @SourceTenantId bigint, @StepName sysname
as
begin
	set nocount on
	if dbo.fnHasModuleBeenExecuted(@NewTenantId, @SourceTenantId, @StepName) = 1 return

	if @NewTenantId is null or @SourceTenantId is null or nullif(@StepName,'') is null begin
		raiserror('spStopCreateTenantModule cannot have null parameters', 16,1)
		return
	end

	update dbo.TCreateTenantStep
	set FinishedAt = GetDate()
	where SourceTenantId=@SourceTenantId 
		and NewTenantId=@NewTenantId 
		and StepName=@StepName

	if @@rowcount != 0
		
	print 'Stoping module: '+@StepName
end
GO
