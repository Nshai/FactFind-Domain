USE CRM
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date        Modifier        Issue         Description
----        ---------       -------       -------------
20201027    Nick Fairway    IP-90443      Performance issue: Check existence in TOpportunity and use index o IndigoClientId in TOrganiserActivity
20230503    Rahul Sankar    IOSE22-1850   Renaming 'Binder' to 'Folder' for opportunity linked entities
*/
CREATE PROCEDURE dbo.nio_SpCustomExtractOpportunityLinkedEntities
    @OpportunityId Bigint
AS
	DECLARE @LinkedEntities varchar(255) = NULL, @TenantId       int = null

SELECT @TenantId = IndigoClientId FROM dbo.TOpportunity WHERE OpportunityId = @OpportunityId

IF @TenantId IS NOT NULL -- It does not exist in TOpportunity and should not exist in any of the below
BEGIN

    --Is plan linked to an opportunity
    IF EXISTS (SELECT TOP 1 1 FROM dbo.TOpportunityPolicyBusiness WHERE OpportunityId = @OpportunityId)
	    SET @LinkedEntities = CONCAT(@LinkedEntities, 'Plan')

    --Is fee linked to an opportunity
    IF EXISTS (SELECT TOP 1 1 FROM dbo.TOpportunityFee WHERE OpportunityId = @OpportunityId)
	    SET @LinkedEntities = COALESCE(CONCAT(@LinkedEntities + ', ','Fee'),'Fee')

    --Is goal linked to an opportunity
    IF EXISTS (SELECT TOP 1 1 FROM dbo.TOpportunityObjective WHERE OpportunityId = @OpportunityId)
	    SET @LinkedEntities = COALESCE(CONCAT(@LinkedEntities + ', ','Goal'),'Goal')

    --Is binder linked to an opportunity
    IF EXISTS (SELECT TOP 1 1 FROM  dbo.TOpportunityBinder WHERE OpportunityId = @OpportunityId)
	    SET @LinkedEntities = COALESCE(CONCAT(@LinkedEntities + ', ','Folder'),'Folder')

    --Is task linked to an opportunity
    IF EXISTS ( SELECT TOP 1 1 
                FROM    dbo.TOrganiserActivity  a (NOLOCK) -- (!!!! Warning this is a dirty read and can produce inaccurate results. We are prioritising perfromance over accuracy)
                WHERE a.OpportunityId = @OpportunityId AND a.IndigoClientId = @TenantId)-- nullable column but all have values. Using index on IndigoClientId should cut down the rows scanned in most cases 
	    SET @LinkedEntities = COALESCE(CONCAT(@LinkedEntities + ', ','Task'),'Task')
	    
    --Is service case linked to an opportunity
    IF EXISTS (SELECT TOP 1 1 FROM  TServiceCaseToOpportunity WHERE OpportunityId = @OpportunityId)
        SET @LinkedEntities = COALESCE(CONCAT(@LinkedEntities + ', ','Service Case'),'Service Case')
END


SELECT @LinkedEntities
GO
