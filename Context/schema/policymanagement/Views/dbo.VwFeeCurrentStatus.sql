
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VwFeeCurrentStatus] 
AS




Select A.*  from TFeeStatus A
INNER JOIN (
	Select FeeId, Max(FeeStatusId) as FeeStatusId from TFeeStatus
	Group by FeeId
) B ON A.FeeStatusId = B.FeeStatusId