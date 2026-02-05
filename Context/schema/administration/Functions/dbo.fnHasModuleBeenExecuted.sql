SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fnHasModuleBeenExecuted](@NewTenantId bigint, @SourceTenantId bigint, @StepName sysname)
returns bit
as
begin
	if exists(select 1 from dbo.TCreateTenantStep 
		where SourceTenantId=@SourceTenantId 
			and NewTenantId=@NewTenantId 
			and StepName=@StepName 
			and FinishedAt is not null)
		return 1
	
	return 0
end
GO
