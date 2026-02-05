SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditValBulkPershingFund]
	@StampUser varchar (255),
	@ValBulkPershingFundId int,
	@StampAction char(1)
AS

insert into TValBulkPershingFundAudit(ValBulkPershingFundId, SedolCode, FundName, stampdatetime, stampuser, stampaction) 
select ValBulkPershingFundId, SedolCode, FundName, getdate(), @stampuser, @stampaction from TValBulkPershingFund where ValBulkPershingFundId = @ValBulkPershingFundId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
