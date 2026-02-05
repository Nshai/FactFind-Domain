SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditPolicyBusinessFundAttribute]
	@StampUser varchar (255),
	@PolicyBusinessFundAttributeId bigint,
	@StampAction char(1)
AS

INSERT INTO [PolicyManagement].[dbo].[TPolicyBusinessFundAttributeAudit]
            (
				PolicyBusinessFundId
				,RefFundAttributeId
				,ConcurrencyId
				,PolicyBusinessFundAttributeId
				,StampAction
				,StampDateTime
				,StampUser
           )
Select 
	PolicyBusinessFundId
    ,RefFundAttributeId		
	,ConcurrencyId
	,PolicyBusinessFundAttributeId
	,@StampAction
	,GetDate()
	,@StampUser
FROM [PolicyManagement].[dbo].[TPolicyBusinessFundAttribute]
WHERE PolicyBusinessFundAttributeId = @PolicyBusinessFundAttributeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
