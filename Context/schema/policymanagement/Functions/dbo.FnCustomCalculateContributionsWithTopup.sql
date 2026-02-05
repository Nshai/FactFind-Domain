SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[FnCustomCalculateContributionsWithTopup]
(
@TenantId bigint,
@PolicyBusinessId bigint,       
@ContributorType varchar(50),
@ContributionType varchar(50),
@BaseFrequency varchar(50),
@IsInvestment bit,
@CurrentUserDate datetime
)    
RETURNS money
AS
BEGIN
DECLARE @OnlyCurrent BIT = CASE WHEN @ContributionType = 'Regular' THEN 1 ELSE 0 END 
DECLARE @RefContributionTypeIds TABLE (Id BIGINT NOT NULL)
DECLARE @RefContributorTypeIds TABLE (Id BIGINT NOT NULL)
DECLARE @Contributions TABLE (PolicyBusinessId BIGINT NOT NULL, Amount MONEY, Frequency VARCHAR(50))
DECLARE @Plans TABLE (PolicyBusinessId BIGINT NOT NULL)

IF @BaseFrequency IS NULL OR @BaseFrequency = ''
	SET @BaseFrequency = 'Monthly'

------------------------------------------------------
-- Get contribution/contributor details.
------------------------------------------------------
INSERT INTO @RefContributionTypeIds (Id)
SELECT RefContributionTypeId
FROM PolicyManagement..TRefContributionType 
WHERE RefContributionTypeName = @ContributionType

IF @ContributionType = 'Lump Sum' AND @IsInvestment = 1
BEGIN
	INSERT INTO @RefContributionTypeIds (Id)
	SELECT RefContributionTypeId
	FROM PolicyManagement..TRefContributionType 
	WHERE RefContributionTypeName IN ('Transfer', 'Rebate')	
END

INSERT INTO @RefContributorTypeIds (Id)
SELECT RefContributorTypeId
FROM PolicyManagement..TRefContributorType 
WHERE RefContributorTypeName = @ContributorType

------------------------------------------------------
-- Find all plans/topups, this is the main plan
------------------------------------------------------
INSERT INTO @Plans
SELECT @PolicyBusinessId

------------------------------------------------------
-- These are the topups
------------------------------------------------------
INSERT INTO @Plans
SELECT PB.PolicyBusinessId
FROM 
	PolicyManagement..TPolicyBusiness PB WITH(NOLOCK)
WHERE 
	PB.IndigoClientId = @TenantId AND -- use tenant id here to target the clustered index.
	PB.TopupMasterPolicyBusinessId = @PolicyBusinessId

------------------------------------------------------
-- Get contributions for our list of plans
------------------------------------------------------
INSERT INTO @Contributions (PolicyBusinessId, Amount)
SELECT PB.PolicyBusinessId, dbo.FnConvertFrequency(@BaseFrequency, FRQ.FrequencyName, PMI.Amount)
FROM 
	PolicyManagement..TPolicyBusiness PB WITH(NOLOCK)
	JOIN PolicyManagement..TStatusHistory SH WITH(NOLOCK) ON PB.PolicyBusinessId = SH.PolicyBusinessId AND SH.CurrentStatusFG = 1
	JOIN PolicyManagement..TStatus ST WITH(NOLOCK) ON SH.StatusId = ST.StatusId
	JOIN PolicyManagement..TPolicyMoneyIn PMI WITH(NOLOCK) ON PB.PolicyBusinessId = PMI.PolicyBusinessId
	JOIN PolicyManagement..TRefFrequency FRQ WITH(NOLOCK) ON PMI.RefFrequencyId = FRQ.RefFrequencyId
WHERE 
	ST.IntelligentOfficeStatusType IN ('In Force', 'Paid Up')	AND
	PB.PolicyBusinessId IN (SELECT PolicyBusinessId FROM @Plans) AND
	PMI.RefContributionTypeId IN (SELECT Id FROM @RefContributionTypeIds) AND
	(@ContributorType IS NULL OR PMI.RefContributorTypeId  IN (SELECT Id FROM @RefContributorTypeIds)) AND
	(@OnlyCurrent = 0 OR (@OnlyCurrent = 1 AND @CurrentUserDate BETWEEN PMI.StartDate AND ISNULL(PMI.StopDate, @CurrentUserDate))) 

RETURN (SELECT SUM(ISNULL(Amount,0)) FROM @Contributions)

END
GO
