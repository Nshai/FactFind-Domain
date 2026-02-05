SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


Create PROCEDURE [dbo].[SpNAuditMortgageChecklistCategory]
	@StampUser varchar (255),
	@MortgageChecklistCategoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TMortgageChecklistCategoryAudit 
( MortgageChecklistCategoryId, MortgageChecklistCategoryName,TenantId,ArchiveFG,ConcurrencyId,[Ordinal],[SystemFG],StampAction, StampDateTime, StampUser) 
Select
 MortgageChecklistCategoryId, MortgageChecklistCategoryName,TenantId,ArchiveFG,ConcurrencyId,[Ordinal],[SystemFG], @StampAction, GetDate(), @StampUser
FROM TMortgageChecklistCategory
WHERE MortgageChecklistCategoryId = @MortgageChecklistCategoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)



GO
