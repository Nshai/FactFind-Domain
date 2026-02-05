SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomClientHasSummary]
	@StampUser varchar(255),  
	@CRMContactId bigint,  
	@CRMContactType bigint,  
	@IndigoClientId bigint
AS  
DECLARE @FactFindId bigint  
  
-- Get the factFind record for the client
SELECT FactFindId, CRMContactId1, CRMContactId2
FROM TFactFind 
WHERE CrmContactId1 = @CrmContactId OR CrmContactId2 = @CrmContactId
  
-- If there are no records for the client then add a new one.
IF @@ROWCOUNT = 0
BEGIN  
	-- Add the fact find (we used to add FactFindTypeId here but shouldn't be needed anymore)
	INSERT INTO TFactFind(CRMContactId1, CRMContactId2, IndigoClientId)
	VALUES (@CRMContactId, 0, @IndigoClientId)
	-- Audit
	SET @FactFindId = SCOPE_IDENTITY()
	EXEC SpNAuditFactFind @StampUser, @FactFindId, 'C'			
	-- Add default expenditure items
	EXEC SpNCustomCreateDefaultExpenditure @StampUser, @CRMContactId	
	-- Return data
	SELECT FactFindId, CRMContactId1, CRMContactId2
	FROM TFactFind 
	WHERE FactFindId = @FactFindId
END
GO
