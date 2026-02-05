SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[SpCustomCreatePolicyBusinessFundAttributeMask]
	(
		@PolicyBusinessFundId bigint,
		@AttributeMask bigint,
		@StampUser varchar(255)
	)
AS

begin

	insert into TPolicyBusinessFundAttributeMask (PolicyBusinessFundId, AttributeMask, ConcurrencyId)

		output INSERTED.PolicyBusinessFundAttributeMaskId, INSERTED.PolicyBusinessFundId, INSERTED.AttributeMask, INSERTED.ConcurrencyId, 'C', Getdate(), @StampUser
		into TPolicyBusinessFundAttributeMaskAudit (PolicyBusinessFundAttributeMaskId, PolicyBusinessFundId, AttributeMask, ConcurrencyId, StampAction, StampDateTime, StampUser)

	Values (@PolicyBusinessFundId,@AttributeMask, @AttributeMask )

end
GO
