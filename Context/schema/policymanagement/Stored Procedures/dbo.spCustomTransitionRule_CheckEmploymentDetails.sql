SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckEmploymentDetails]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(max) output
AS
	
	Declare @ClientCount tinyint
	Declare @ClientType varchar(10)
	Declare @Owner1Id Bigint 
	Declare @Owner2Id Bigint 
	Declare @Owner1Name Varchar(255) 
	Declare @Owner2Name Varchar(255)  

	EXEC spCustomTansitionRuleGetOwners @PolicyBusinessId, 
										@ClientCount OUTPUT, @ClientType OUTPUT,
										@Owner1Id OUTPUT, @Owner1Name OUTPUT, 
										@Owner2Id OUTPUT, @Owner2Name OUTPUT
										
	--Only applies to person clients
	if @ClientType != 'PERSON'
		return(0)	
	
	--Check Fack Find 
	declare @FactFindId bigint = null
	declare @FactFindPrimaryOwnerId bigint	= null
	
	EXEC spCustomTansitionRule_CheckFactFind @Owner1Id, @Owner2Id, @Owner1Name, @Owner2Name, @ClientCount, 
		@FactFindId OUTPUT, @FactFindPrimaryOwnerId OUTPUT, @ErrorMessage OUTPUT
	
	if ISNULL(@ErrorMessage, '') != ''
		return 	
	
	
	Declare @SequentialRef Varchar(20) = (Select SequentialRef from TPolicyBusiness where PolicyBusinessId = @PolicyBusinessId)
	
	Declare @EmploymentDetails TABLE 
	(		
			PlanId Bigint, SequentialRef varchar(20), OwnerId Bigint, OwnerName Varchar(150), --Required
			EmploymentDetailId Bigint, EmploymentStatus  varchar(30), [Role] varchar(512), 
			HasStatus  varchar(30), Occupation varchar(3), IntendedRetirementAge varchar(3), Employer varchar(3), 
			BasicAnnualIncome varchar(3), MostRecentAnnualNetProfit varchar(3), StartDate varchar(3), EndDate varchar(3)
	)
	
	

	INSERT INTO @EmploymentDetails
	
	SELECT DISTINCT @PolicyBusinessId, @SequentialRef, 
		A.CRMContactId,																		-- OwnerId		
		CASE 
			WHEN A.CRMContactId = @Owner1Id THEN @Owner1Name 
			WHEN A.CRMContactId = @Owner2Id THEN @Owner2Name
		End,																				-- Owner Name
		A.EmploymentDetailId, A.EmploymentStatus, A.[Role],									-- Employment Details
		
		CASE WHEN A.EmploymentStatus IS NULL THEN 'NO' ELSE 'YES' END,						--Has Status
		
		CASE WHEN ISNULL(A.[Role], '') = ''													-- Occupation
			AND ISNULL(A.EmploymentStatus,'') NOT IN ('', 'Unemployed', 'Houseperson', 'Retired', 'Student')
			THEN 'NO' ELSE 'YES' 
		END,																				
		
		CASE WHEN A.IntendedRetirementAge IS NULL											-- IntendedRetirementAge	
			AND ISNULL(A.EmploymentStatus,'') NOT IN ('', 'Unemployed', 'Houseperson', 'Retired', 'Student')
			THEN 'NO' ELSE 'YES' 
		END,
		
		CASE WHEN A.Employer IS NULL														-- Employer	
			AND A.EmploymentStatus IN ('Employed', 'Company Director', 'Semi-Retired', 'Maternity Leave', 'Long Term Illness')
			THEN 'NO' ELSE 'YES' 
		END,
		
		CASE WHEN A.BasicAnnualIncome IS NULL											--  Basic Annual Income	
			AND A.EmploymentStatus IN ('Employed', 'Company Director', 'Semi-Retired', 'Maternity Leave', 'Long Term Illness')
			THEN 'NO' ELSE 'YES' 
		END,	
		
		CASE WHEN A.PreviousFinancialYear IS NULL											-- Most recent annual Net Profit	
			AND A.EmploymentStatus IN ('Self-employed', 'Contract Worker')
			THEN 'NO' ELSE 'YES' 
		END,	
		
		CASE WHEN A.StartDate IS NULL														-- StartDate	
			AND A.EmploymentStatus IN ('Contract Worker')
			THEN 'NO' ELSE 'YES' 
		END,
		
		CASE WHEN A.EndDate IS NULL															-- StartDate	
			AND A.EmploymentStatus IN ('Contract Worker')
			THEN 'NO' ELSE 'YES' 
		END		
		
	FROM factfind..TEmploymentDetail A 
	WHERE A.CRMContactId IN (@Owner1Id, @Owner2Id)
	
	
	--Return if none found
	IF (SELECT COUNT(1) FROM @EmploymentDetails) = 0 
		RETURN(0)
	
	--Remove where all Positive hits
	DELETE FROM @EmploymentDetails 
	WHERE Occupation = 'YES' AND IntendedRetirementAge = 'YES' AND Employer = 'YES' AND BasicAnnualIncome = 'YES' AND MostRecentAnnualNetProfit = 'YES' AND StartDate = 'YES' AND EndDate = 'YES' AND HasStatus = 'YES'
	
	--Remove Positive hits
	DELETE FROM @EmploymentDetails 
	WHERE Occupation = 'YES' AND IntendedRetirementAge = 'YES' 
	AND ISNULL(EmploymentStatus,'') NOT IN ('', 'Unemployed', 'Houseperson', 'Retired', 'Student')
	AND Employer = 'YES' AND BasicAnnualIncome = 'YES' AND MostRecentAnnualNetProfit = 'YES' AND StartDate = 'YES' AND EndDate = 'YES' -- this is needed because status is checked using NOT IN, meaining it includes the statusees mentioned below too
	AND HasStatus = 'YES'
	
	--Remove Positive hits
	DELETE FROM @EmploymentDetails 
	WHERE Employer = 'YES' AND BasicAnnualIncome = 'YES'
	AND EmploymentStatus IN ('Employed', 'Company Director', 'Semi-Retired', 'Maternity Leave', 'Long Term Illness')
	AND Occupation = 'YES' AND IntendedRetirementAge = 'YES' 
	
	--Remove Positive hits
	DELETE FROM @EmploymentDetails 
	WHERE MostRecentAnnualNetProfit = 'YES'
	AND EmploymentStatus IN ('Self-employed', 'Contract Worker')
	AND Occupation = 'YES' AND IntendedRetirementAge = 'YES' AND StartDate = 'YES' AND EndDate = 'YES'
	
	--Remove Positive hits
	DELETE FROM @EmploymentDetails 
	WHERE StartDate = 'YES' AND EndDate = 'YES'
	AND EmploymentStatus IN ('Contract Worker')
	AND Occupation = 'YES' AND IntendedRetirementAge = 'YES' AND MostRecentAnnualNetProfit = 'YES'
	
	--Return if none left
	IF (SELECT COUNT(1) FROM @EmploymentDetails) = 0 
		RETURN(0)
	
	
	

	DECLARE @Ids VARCHAR(max)  
		SELECT @Ids = COALESCE(@Ids + '&&', '') + 
			'PlanId=' + convert(varchar(50),PlanId) + '::'+  
			'SequentialRef=' + convert(varchar(50),SequentialRef)  + '::'+  
			'FactFindId=' + convert(varchar(20),@FactFindId) + '::'+  
			'FactFindPrimaryOwnerId=' + convert(varchar(20),@FactFindPrimaryOwnerId) + '::'+  
			'OwnerId=' + convert(varchar(20),OwnerId) + '::'+  
			'OwnerName=' + convert(varchar(20),OwnerName) + '::'+  
			'EmploymentDetailId=' + convert(varchar(50),EmploymentDetailId) + '::' +  
			'EmploymentStatus=' + ISNULL(EmploymentStatus, 'blank')  + '::' +  
			'Role=' + ISNULL([Role], 'blank') + '::' +  
			'HasStatus=' + ISNULL(HasStatus, 'blank')  + '::' + 
			'Occupation='+ Occupation + '::' +  
			'IntendedRetirementAge='+ IntendedRetirementAge + '::' +  
			'Employer='+ Employer + '::' +  
			'BasicAnnualIncome=' + BasicAnnualIncome + '::' +  
			'MostRecentAnnualNetProfit='+ MostRecentAnnualNetProfit + '::' +  
			'StartDate='+ StartDate + '::' +  
			'EndDate='+ EndDate 		
			
		FROM @EmploymentDetails
				
		SELECT @ErrorMessage = 'EMPLOYMENTDETAILS_' + @Ids

	

GO
