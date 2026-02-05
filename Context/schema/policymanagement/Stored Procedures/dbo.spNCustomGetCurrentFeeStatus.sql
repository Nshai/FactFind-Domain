SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[spNCustomGetCurrentFeeStatus]
	@FeeId bigint
 AS

Declare @Status varchar(255)

SET @Status = (SELECT Status FROM TFeeStatus 
WHERE FeeStatusId IN(
	SELECT MAX(FeeStatusId) 
	FROM TFeeStatus
	WHERE FeeId = @FeeId
	)
)


--Return the Status for a Fee
Select @Status
GO
