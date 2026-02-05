SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_WithdrawPolicy]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(512) output
AS

--    Check If Policy Has been Matched Against for a Commission.
      IF (SELECT COUNT(ProvBreakId) FROM [Commissions].[dbo].TProvBreak WHERE PolicyId = @PolicyBusinessId) > 0
        BEGIN
           SELECT @ErrorMessage = 'CASHMATCHED'
        END
--      ELSE
--        BEGIN
--           DELETE FROM [Commissions].[dbo].TDnPolicyMatching WHERE PolicyId = @PolicyBusinessId
--        END






GO
