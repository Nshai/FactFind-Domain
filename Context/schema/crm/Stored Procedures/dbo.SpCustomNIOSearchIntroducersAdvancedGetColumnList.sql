SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.SpCustomNIOSearchIntroducersAdvancedGetColumnList
AS

BEGIN

	SELECT
		0 AS [CRMContactId],
		0 AS [IntroducerId],
		0 AS [RefIntroducerTypeId],
		0 AS [IsArchived],
		0 AS [IsActive],
		'' AS [Identifier],
		'' AS [UniqueIdentifier],
		0 AS [ConcurrencyId],
		'' AS [IntroducerTypeLongName],
		0 AS [IntroducerTypeCanReceiveRenewals],
		0 AS [IntroducerTypeDefaultSplitPercentage],
		'' AS [IntroducerName],
		0 AS [CRMContactType],
		0 AS [AssignedAdviserId],
		'' AS [AssignedAdviserFullName]
		
END
GO
