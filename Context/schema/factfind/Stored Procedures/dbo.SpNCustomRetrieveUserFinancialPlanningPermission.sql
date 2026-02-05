SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpNCustomRetrieveUserFinancialPlanningPermission] @CRMContactId bigint, @UserId bigint

as

declare @status varchar(255), @FinancialPlanningAccess bit

select @status =	[status]
					from	administration..TUser a					
					where	a.CRMContactId = @CRMContactId


select @FinancialPlanningAccess = isnull(FinancialPlanningAccess,0)
					from administration..TUser
					where userid = @UserId	

if(@status like '%Access Granted%' and @FinancialPlanningAccess = 1)  begin

	select 1

end
else begin

	select 0

end
GO
