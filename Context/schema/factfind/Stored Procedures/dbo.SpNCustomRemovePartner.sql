SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRemovePartner] 
	@StampUser varchar(255),
	@FactFindId bigint
AS



BEGIN

	INSERT INTO TFactFindAudit(CRMContactId1, CRMContactId2, FactFindTypeId, IndigoClientId, ConcurrencyId, FactFindId, StampAction, StampDateTime, StampUser)
	SELECT 
		CRMContactId1, CRMContactId2, FactFindTypeId, IndigoClientId, ConcurrencyId, FactFindId, 'U', GETDATE(), @StampUser
	FROM 
		TFactFind
	WHERE
		FactFindId = @FactFindId
		
	UPDATE 
		TFactFind
	SET
		CRMContactId2 = 0,
		ConcurrencyId = ConcurrencyId + 1
	WHERE
		FactFindId = @FactFindId
	
END
GO
