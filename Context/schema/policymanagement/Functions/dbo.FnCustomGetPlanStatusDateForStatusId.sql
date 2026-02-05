SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION  dbo.FnCustomGetPlanStatusDateForStatusId(@PolicyBusinessId bigint, @StatusId bigint)
RETURNS datetime
AS
BEGIN
	DECLARE @StatusDate Datetime
	
	Select @StatusDate = T2.ChangedToDate
	From PolicyManagement.dbo.TStatusHistory T2 With(NoLock)
	Where T2.StatusHistoryId In
	(
		Select Max(StatusHistoryId)
		From PolicyManagement.dbo.TStatusHistory TSH With(NoLock)
		Where TSH.StatusId = @StatusId And TSH.PolicyBusinessId = @PolicyBusinessId
		Group By TSH.PolicyBusinessId
	)

	RETURN (@StatusDate)
END




GO
