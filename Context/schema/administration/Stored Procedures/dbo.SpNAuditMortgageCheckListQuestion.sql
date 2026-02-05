USE [administration]
GO

/****** Object:  StoredProcedure [dbo].[SpNAuditMortgageChecklistQuestion]    Script Date: 07/10/2013 07:33:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

Create PROCEDURE [dbo].[SpNAuditMortgageCheckListQuestion]
	@StampUser varchar (255),
	@MortgageChecklistQuestionId bigint,
	@StampAction char(1)
AS

INSERT INTO TMortgageChecklistQuestionAudit 
( MortgageChecklistQuestionId, Question,MortgageChecklistCategoryId,Ordinal ,
	IsArchived, TenantId,ParentQuestionId,SystemFG,
	StampAction, StampDateTime, StampUser,	ConcurrencyId) 
Select MortgageChecklistQuestionId, Question,MortgageChecklistCategoryId,Ordinal ,
	IsArchived, TenantId,ParentQuestionId,SystemFG,
	@StampAction, GetDate(), @StampUser,ConcurrencyId
FROM TMortgageChecklistQuestion
WHERE MortgageChecklistQuestionId = @MortgageChecklistQuestionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO


