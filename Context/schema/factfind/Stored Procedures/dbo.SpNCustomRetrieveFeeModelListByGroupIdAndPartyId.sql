SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrieveFeeModelListByGroupIdAndPartyId] 

@UserId BIGINT,
@TenantId BIGINT,
@PartyId BIGINT = 0

AS

DECLARE @ServiceStatusId BIGINT
SET @ServiceStatusId = 0 

DECLARE @FeeModelId BIGINT
SET @FeeModelId = 0

DECLARE @UserGroupId BIGINT
SELECT @UserGroupId = GroupId FROM Administration..Tuser WHERE UserId = @UserId

DECLARE @DateCheck DATETIME
SELECT @DateCheck= CAST(CAST(GETDATE() AS DATE) AS DATETIME)

-- Get the Service Case, Fee Model Id from CRMContactId
IF ISNULL(@PartyId,0) > 0
BEGIN
	SELECT @ServiceStatusId = ISNULL(RefServiceStatusId,0) FROM CRM..TCRMContact
	WHERE CRMContactId = @PartyId
	
	SELECT @FeeModelId = ISNULL(FeeModelId,0) FROM CRM..TCRMContact
	WHERE CRMContactId = @PartyId
END

-- Two seperate return of Fee Model Lists
-- 1.) If the Client Party has a fee model then return the list based on the Service Status
If (@ServiceStatusId > 0)
	BEGIN
		SELECT 
		 FeeModel.FeeModelId AS FeeModelId
		, FeeModel.Name AS FeeModelName
		, RefServiceStatus.IsDefault AS IsDefault 
		, CASE FeeModel.FeeModelId
			WHEN @FeeModelId THEN 1
			ELSE 0 END
			AS IsSelectedFeeModelId
		
		FROM CRM..TRefServiceStatusToFeeModel RefServiceStatus
		INNER JOIN PolicyManagement..TFeeModel FeeModel ON RefServiceStatus.FeeModelId=FeeModel.FeeModelId 
		LEFT OUTER JOIN PolicyManagement..TRefFeeModelStatus RefFeeModelStatus ON FeeModel.RefFeeModelStatusId=RefFeeModelStatus.RefFeeModelStatusId 
		
		WHERE 
			RefServiceStatus.TenantId = @TenantId 
			AND RefServiceStatus.RefServiceStatusId = @ServiceStatusId 
			AND (FeeModel.StartDate <= @DateCheck OR FeeModel.StartDate IS NULL) 
			AND (FeeModel.EndDate >= @DateCheck OR FeeModel.EndDate IS NULL) 
			AND RefFeeModelStatus.RefFeeModelStatusId = 2 -- Approved
			AND (FeeModel.GroupId = @UserGroupId OR FeeModel.GroupId IS NULL)
			
			ORDER BY FeeModel.Name asc
	END
ELSE
-- Else 2.) List all the fee models that are approved etc. 
	BEGIN
		SELECT 
		FeeModel.FeeModelId AS FeeModelId
		, FeeModel.Name AS FeeModelName 
		, 0 AS IsDefault
		, 0 AS IsSelectedFeeModelId
		
		FROM PolicyManagement..TFeeModel FeeModel 
		LEFT OUTER JOIN PolicyManagement..TRefFeeModelStatus RefFeeModelStatus ON FeeModel.RefFeeModelStatusId=RefFeeModelStatus.RefFeeModelStatusId 
		LEFT OUTER JOIN Administration..TGroup Grp ON FeeModel.GroupId=Grp.GroupId 
		
		WHERE 
		FeeModel.TenantId = @TenantId 
		AND RefFeeModelStatus.RefFeeModelStatusId = 2 -- Approved
		AND (FeeModel.StartDate <= @DateCheck OR FeeModel.StartDate IS NULL) 
		AND (FeeModel.EndDate >= @DateCheck OR FeeModel.EndDate IS NULL)  
		AND (Grp.GroupId = @UserGroupId OR Grp.GroupId IS NULL)
		
		ORDER BY FeeModel.Name asc
	END
GO
