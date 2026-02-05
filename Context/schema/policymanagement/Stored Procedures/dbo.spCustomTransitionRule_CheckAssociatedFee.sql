SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckAssociatedFee]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(512) output
AS

BEGIN
	
	--make sure the plan is linked to a Fee
	if(select count(FeeId) from TFee2Policy WHERE PolicyBusinessId = @PolicyBusinessId) = 0
	begin
		select @ErrorMessage = 'ASSOCIATEDFEE'  
	end
	
END




GO
