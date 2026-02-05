SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateObjectiveOpportunity]
	@StampUser varchar(255),	
	@ObjectiveId bigint,
	@CRMContactId bigint,
	@ObjectiveTypeId bigint,
	@StartDate datetime,
	@CurrentUserDate datetime
AS
-- Declarations
DECLARE @OpportunityTypeId bigint, @OpportunityId bigint, @InitialStatusId bigint, @StatusHistoryId bigint, @OpportunityCustomerId bigint,
	@IndigoClientId bigint, @CreatedDate datetime, @PractitionerId bigint, @AutoCreateOpportunityOption bigint, @RefUserTypeId bigint

-- Get IndigoClientId
SELECT @IndigoClientId = IndClientId FROM CRM..TCRMContact WHERE CRMContactId = @CRMContactId
-- Get user type.
SELECT @RefUserTypeId = RefUserTypeId FROM Administration..TUser WHERE UserId = CAST(@StampUser AS bigint)

-- check the settings for the active atr template
SET @AutoCreateOpportunityOption = 1 -- Default to Nobody
SELECT 
	@AutoCreateOpportunityOption = AutoCreateOpportunities
FROM
	FactFind..TAtrTemplate AT 	
	JOIN FactFind..TAtrTemplateSetting ATS ON AT.AtrTemplateId = ATS.AtrTemplateId
WHERE
	AT.IndigoClientId = @IndigoClientId
	AND AT.Active = 1

-- If Nobody is configured to add opportunities then stop.		
IF @AutoCreateOpportunityOption = 1
	RETURN
-- Adviser only	
ELSE IF @AutoCreateOpportunityOption = 2 AND @RefUserTypeId = 2
	RETURN
-- Client Portal only	
ELSE IF @AutoCreateOpportunityOption = 3 AND @RefUserTypeId = 1
	RETURN
	
-- Get default opp type
SELECT 
	@OpportunityTypeId = OpportunityTypeId	
FROM
	CRM..TOpportunityType
WHERE
	IndigoClientId = @IndigoClientId
	AND ((InvestmentDefault = 1 AND @ObjectiveTypeId = 1)
		 OR (RetirementDefault = 1 AND @ObjectiveTypeId = 2))

-- Have we got a default Opportunity Type?
IF @OpportunityTypeId IS NULL
	RETURN;

----------------------------------------------------------
-- Link to Opportunity....
----------------------------------------------------------		

-- Get current adviser
SELECT
	@PractitionerId = P.PractitionerId
FROM	
	CRM..TPractitioner P
	JOIN CRM..TCRMContact C ON C.CurrentAdviserCRMId = P.CRMContactId
WHERE
	C.CRMContactId = @CRMContactId
	
-- default start date
IF @StartDate IS NULL 
	SET @StartDate = CONVERT(datetime, CONVERT(varchar(12), GETDATE(), 106))
SET @CreatedDate = CONVERT(datetime, CONVERT(varchar(12), @CurrentUserDate, 106))

-- default status.
SELECT @InitialStatusId = OpportunityStatusId FROM CRM..TOpportunityStatus WHERE IndigoClientId = @IndigoClientId AND InitialStatusFG = 1        

-- Add the opportunity                          
INSERT INTO CRM..TOpportunity (          
	IndigoClientId, OpportunityTypeId, CreatedDate, PractitionerId, IsClosed, ConcurrencyId )           
VALUES (          
	@IndigoClientId, @OpportunityTypeId, @CreatedDate, @PractitionerId, 0, 1)           

SELECT @OpportunityId = SCOPE_IDENTITY()
EXEC CRM..SpNAuditOpportunity @StampUser, @OpportunityId, 'C'
                    
-- Add a status record        
INSERT CRM..TOpportunityStatusHistory(OpportunityId,OpportunityStatusId,DateOfChange,ChangedByUserId,CurrentStatusFG,ConcurrencyId)        
SELECT @OpportunityId, @InitialStatusId, GETDATE(), @StampUser, 1, 1        
    
SELECT @StatusHistoryId = SCOPE_IDENTITY()
EXEC CRM..SpNAuditOpportunityStatusHistory @StampUser, @StatusHistoryId, 'C'	             

-- Add Opp Customer record.        
INSERT INTO CRM..TOpportunityCustomer(OpportunityId, PartyId)
VALUES (@OpportunityId, @CRMContactId)

SELECT @OpportunityCustomerId = SCOPE_IDENTITY()
EXEC CRM..SpNAuditOpportunityCustomer @StampUser = @StampUser, @OpportunityCustomerId = @OpportunityCustomerId, @StampAction = 'C'	             
        
-- Link to objective
EXEC CRM..SpCreateOpportunityObjective @StampUser, @OpportunityId, @ObjectiveId  
GO
