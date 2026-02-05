SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpNCustomUpdateReservedValueOnPlan]
            @PolicyBusinessId bigint,
            @ReservedValue decimal(18,2),
            @StampUser varchar(255)

as


declare @ExtendedId bigint

select @ExtendedId  = PolicyBusinessExtId 
						from policymanagement..TPolicyBusinessExt
						where policybusinessid = @PolicyBusinessId


if(@ExtendedId is null) begin
	exec @ExtendedId =  policymanagement..SpNCreatePolicyBusinessExtReturnId @StampUser, @PolicyBusinessId, 0, NULL, NULL	
end

exec policymanagement..SpNAuditPolicyBusinessExt @StampUser, @ExtendedId, 'U'

update	policymanagement..TPolicyBusinessExt
set		ReservedValue = @ReservedValue,
		ConcurrencyId = ConcurrencyId +1
where	PolicyBusinessId = @PolicyBusinessId



GO
