SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateDefaultExpenditure]
	@StampUser varchar(255),
	@CRMContactId bigint
AS
IF EXISTS (SELECT 1 FROM TExpenditureDetail WHERE CRMContactId = @CRMContactId)
	RETURN;

-- Add full list of expendture items for the client
INSERT INTO TExpenditureDetail (CRMContactId, RefExpenditureTypeId)
SELECT @CRMContactId, RefExpenditureTypeId
FROM TRefExpenditureType

-- Add audits
INSERT INTO TExpenditureDetailAudit (ExpenditureDetailId, ConcurrencyId, CRMContactId, RefExpenditureTypeId, StampUser, StampDateTime, StampAction)
SELECT ExpenditureDetailId, ConcurrencyId, @CRMContactId, RefExpenditureTypeId, @StampUser, GETDATE(), 'C'
FROM TExpenditureDetail
WHERE CRMContactId = @CRMContactId
GO
