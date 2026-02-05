SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefFundAttribute]
	@StampUser varchar (255),
	@RefFundAttributeId bigint,
	@StampAction char(1)
AS

INSERT INTO [PolicyManagement].[dbo].[TRefFundAttributeAudit]
            (
				AttributeName
				,AttributeCode
				,ConcurrencyId
				,RefFundAttributeId
				,StampAction
				,StampDateTime
				,StampUser
           )
Select 
	AttributeName
    ,AttributeCode		
	,ConcurrencyId
	,RefFundAttributeId
	,@StampAction
	,GetDate()
	,@StampUser
FROM [PolicyManagement].[dbo].[TRefFundAttribute]
WHERE RefFundAttributeId = @RefFundAttributeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
