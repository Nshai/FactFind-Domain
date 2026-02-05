USE policymanagement
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date    Modifier        Issue       Description
----    ---------       -------     -------------
20191113 Yahor Vikharau IP-50151    Client Activity Widget showing incorrect number of documents - also plans, fees and activities counts.
20191024 Nick Fairway   IP-63744    Performance issue. Inconsistent performance  - looks like parameter sniffing so optimize for unknown.

*/
CREATE PROCEDURE dbo.SpCustomDashboardRetrieveClientActivity
	@UserId bigint,
	@cid bigint,
	@TenantId int
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @NumDocuments bigint, @NumActivities bigint, @NumOpportunities bigint, @NumFees bigint, @NumPlans bigint
DECLARE	@Activities table (DocumentsCount bigint,ActivitiesCount bigint,OpportunitiesCount bigint,FeesCount bigint,PlansCount bigint)

SET @NumDocuments = (SELECT COUNT(DISTINCT DocumentId) FROM DocumentManagement..TDocumentOwner WHERE IndigoClientId = @TenantId AND CRMContactId = @cid)
-- Tasks for client 1 + 2
SET @NumActivities = (SELECT COUNT(1) FROM CRM..TAppointment WHERE CRMContactId = @cid And ScratchFg = 0)
SET @NumActivities = @NumActivities + (SELECT COUNT(1) FROM CRM..TTask WHERE IndigoClientId = @TenantId AND CRMContactId = @cid)
SET @NumActivities = @NumActivities + (SELECT COUNT(1) FROM CRM..TOrganiserActivity WHERE IndigoClientId = @TenantId AND JointCRMContactId = @cid AND ISNULL(AppointmentId, TaskId) IS NOT NULL)

SET @NumOpportunities = (SELECT COUNT(OpportunityId) FROM CRM..TOpportunityCustomer WHERE PartyId = @cid)
SET @NumFees = ISNULL((SELECT COUNT(FeeRetainerOwnerId) FROM PolicyManagement..TFeeRetainerOwner WHERE IndigoClientId = @TenantId AND CRMContactId = @cid), 0)
SET @NumFees = @NumFees + ISNULL((SELECT COUNT(FeeRetainerOwnerId) FROM PolicyManagement..TFeeRetainerOwner WHERE IndigoClientId = @TenantId AND SecondaryOwnerId = @cid), 0) -- IP-15292 need to include joint Fees



SELECT @NumPlans = COUNT(tpo.CRMContactId)
FROM PolicyManagement..TPolicyOwner tpo 
	JOIN PolicyManagement..TPolicyDetail tpd ON tpo.PolicyDetailId = tpd.PolicyDetailId
	JOIN PolicyManagement..TPolicyBusiness tpb ON tpb.PolicyDetailId = tpd.PolicyDetailId AND tpb.IndigoClientId = @TenantId
	JOIN PolicyManagement..TStatusHistory sh ON tpb.POlicyBusinessID = sh.PolicyBusinessId
	JOIN PolicyManagement..TStatus s ON s.StatusId = sh.StatusId AND s.IndigoClientId = @TenantId
WHERE tpo.CRMContactId = @cid
	AND sh.CurrentStatusFg = 1
	AND s.IntelligentOfficeStatusType <> 'Deleted'
OPTION (OPTIMIZE FOR UNKNOWN)

INSERT INTO @Activities (DocumentsCount,ActivitiesCount,OpportunitiesCount,FeesCount,PlansCount) 
SELECT @NumDocuments,@NumActivities,@NumOpportunities,@NumFees,@NumPlans

SELECT 
	*,
	@cid as CrmContactId
FROM 
	@Activities

GO
