SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckContribution]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(512) output
AS

      BEGIN

	--make sure that the plan has at least one contribution, and the value of each is > 0
	
	DECLARE @NumPositiveContributions bigint

	SET @NumPositiveContributions = (SELECT count(PolicyBusinessId) FROM TPolicyMoneyIn WHERE PolicyBusinessId = @PolicyBusinessId AND  isnull(Amount,0) > 0)
	
	if @NumPositiveContributions = 0
	begin
		select @ErrorMessage = 'POSITIVECONTRIB'
	end


	

      END


GO
