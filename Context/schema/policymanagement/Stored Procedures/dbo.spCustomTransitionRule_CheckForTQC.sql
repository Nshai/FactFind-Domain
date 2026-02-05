SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckForTQC]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(512) output
AS
--    Check if T&C Coach exisits
       DECLARE @TnCCoachId bigint
       SET @TnCCoachId = (SELECT TnCCoachId FROM TPolicyBusiness WHERE PolicyBusinessId = @PolicyBusinessId)
       IF (ISNULL(@TnCCoachId,'') = '')
       BEGIN
         SELECT @ErrorMessage = 'TQC'
       END


GO
