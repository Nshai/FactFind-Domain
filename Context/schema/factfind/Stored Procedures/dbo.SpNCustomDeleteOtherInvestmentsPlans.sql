SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpNCustomDeleteOtherInvestmentsPlans]
@OtherInvestmentsPlansId bigint,
@StampUser varchar(50),
@CurrentUserDate datetime

AS


EXEC SpNCustomDeletePlan @OtherInvestmentsPlansId, @StampUser, @CurrentUserDate
GO
