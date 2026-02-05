SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_IntroducerSplit]  
  @PolicyBusinessId bigint,  
  @ErrorMessage varchar(512) output  
AS  
  
--    Check if  Introducer split has been added
DECLARE @TotalRegularPremium decimal  
DECLARE @SplitId bigint  

SELECT @SplitId=MIN(SplitId) FROM Commissions..TSplit A WITH(NOLOCK)
					JOIN Commissions..TPaymentEntity B WITH(NOLOCK) ON A.PaymentEntityId=B.PaymentEntityId
					WHERE A.PolicyId=@PolicyBusinessId
					AND B.PractitionerFG=0 AND B.CompanyFG=0 AND B.ClientFG=0 AND B.UserFg=0

IF (ISNULL(@SplitId ,0) = 0)   
BEGIN            
    SELECT @ErrorMessage = 'SPLIT'            
END  



GO
