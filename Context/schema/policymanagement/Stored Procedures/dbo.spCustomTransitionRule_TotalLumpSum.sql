SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_TotalLumpSum]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(512) output
AS

--    Check if  Total Lump Sum is enter
       DECLARE @TotalLumpSum decimal
       DECLARE @SchemeOwnerId bigint

       SELECT @SchemeOwnerId = T1.SchemeOwnerCRMContactId 
       From TPlanDescription T1 
       INNER JOIN TPolicyDetail T2 ON T1.PlanDescriptionId = T2.PlanDescriptionId  
       INNER JOIN TPolicyBusiness T3 ON T3.PolicyDetailId = T2.PolicyDetailId 
       Where T3.PolicyBusinessId = @PolicyBusinessId
       
       IF (ISNULL(@SchemeOwnerId ,'') = '') 
       BEGIN
          SET @TotalLumpSum = (SELECT TotalLumpSum FROM TPolicyBusiness WHERE PolicyBusinessId = @PolicyBusinessId)
          IF (ISNULL(CONVERT(VARCHAR(10),@TotalLumpSum),'') = '')
          BEGIN
            SELECT @ErrorMessage = 'LUMPSUM'
          END
       END



GO
