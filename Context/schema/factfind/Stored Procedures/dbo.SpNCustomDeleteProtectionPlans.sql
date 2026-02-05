SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpNCustomDeleteProtectionPlans] 
@ConcurrencyId bigint,
@ProtectionPlansId bigint,
@StampUser varchar(50),
@CurrentUserDate datetime

AS


EXEC SpNCustomDeletePlan @ProtectionPlansId, @StampUser, @CurrentUserDate
GO
