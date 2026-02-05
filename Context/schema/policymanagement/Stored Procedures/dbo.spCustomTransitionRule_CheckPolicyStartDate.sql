SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckPolicyStartDate]  
  @PolicyBusinessId bigint,  
  @ErrorMessage varchar(512) output  
AS  
  
BEGIN  

	--make sure that the plan has a policynumber  
	DECLARE @PolicyStartDate datetime

	IF EXISTS (SELECT 1 FROM TGroupSchemeMember
			   WHERE PolicyBusinessId = @PolicyBusinessId) BEGIN

			SELECT @PolicyStartDate = JoiningDate  
			FROM TGroupSchemeMember
			WHERE PolicyBusinessId = @PolicyBusinessId

			IF(@PolicyStartDate IS NULL OR @PolicyStartDate < '1 jan 1900')  
				SELECT @ErrorMessage = 'JOINDATE'  
		END
	ELSE BEGIN

		SELECT @PolicyStartDate = PolicyStartDate  
		FROM TPolicyBusiness  
		WHERE PolicyBusinessId = @PolicyBusinessId  

		IF(@PolicyStartDate IS NULL OR @PolicyStartDate < '1 jan 1900')  
			SELECT @ErrorMessage = 'STARTDATE'  

	END
END  


GO
