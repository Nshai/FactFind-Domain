SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomCheckDpGuids]
	@CrmContactId bigint,
	@StampUser varchar(255)
AS
BEGIN
	DECLARE @AdviserId bigint, @IndigoClientId bigint

	-- Get Adviser Id.
	SELECT 
		@AdviserId = P.PractitionerId,
		@IndigoClientId = P.IndClientId
	FROM
		CRM..TPractitioner P
		JOIN CRm..TCRMContact C ON C.CurrentAdviserCRMId = P.CRMContactId AND C.CRMContactId = @CRMContactId

	IF NOT EXISTS (SELECT * FROM TDpGuid WHERE EntityId = @CRMContactId AND DpGuidTypeId = 2)
		EXEC SpCustomCreateDpGuid @StampUser, @CrmContactId, 2

	IF NOT EXISTS (SELECT * FROM TDpGuid WHERE EntityId = @AdviserId AND DpGuidTypeId = 1)
		EXEC SpCustomCreateDpGuid @StampUser, @AdviserId, 1

	IF NOT EXISTS (SELECT * FROM TDpGuid WHERE EntityId = @IndigoClientId AND DpGuidTypeId = 3)
		EXEC SpCustomCreateDpGuid @StampUser, @IndigoClientId, 3

	IF NOT EXISTS (SELECT * FROM TDpPlan WHERE CRMContactId = @CrmContactId)
		EXEC SpCustomCreateDpPlan @StampUser, @CrmContactId, @AdviserId, @IndigoClientId
END

GO
