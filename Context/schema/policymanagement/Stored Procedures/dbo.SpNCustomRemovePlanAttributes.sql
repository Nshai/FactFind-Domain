SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create Procedure [dbo].[SpNCustomRemovePlanAttributes] @PolicyBusinessId bigint,@StampUser varchar(255)

AS


INSERT TPolicyBusinessAttributeAudit(
PolicyBusinessId,
AttributeList2AttributeId,
AttributeValue,
ConcurrencyId,
PolicyBusinessAttributeId,
StampAction,
StampDateTime,
StampUser
)

SELECT PolicyBusinessId,AttributeList2AttributeId,AttributeValue,ConcurrencyId,PolicyBusinessAttributeId,
'D',GETDATE(),@StampUser

FROM TPolicyBusinessAttribute
WHERE PolicyBusinessId=@PolicyBusinessId

IF @@ERROR!=0 GOTO ERRH


DELETE FROM TPolicyBusinessAttribute
WHERE PolicyBusinessId=@PolicyBusinessId

IF @@ERROR!=0 GOTO ERRH

RETURN(0)

ERRH:

RETURN(100)
GO
