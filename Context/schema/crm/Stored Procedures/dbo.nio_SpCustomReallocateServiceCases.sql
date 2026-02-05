SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpCustomReallocateServiceCases]
 @StampUserId varchar (255),  
 @NewAdviserId int, 
 @ServiceCasesIds varchar(max) 
        
AS        

BEGIN
    DECLARE @StampActionUpdate varchar(1) = 'U',
            @StampDateTime datetime = GETUTCDATE()

    CREATE TABLE #TempServiceCasesIds(Id int)

    INSERT INTO #TempServiceCasesIds (Id)
    SELECT value
    FROM STRING_SPLIT(@ServiceCasesIds, ',');

    UPDATE AC
    SET PractitionerId = @NewAdviserId
    OUTPUT
    deleted.CRMContactId
    ,deleted.PractitionerId
    ,deleted.StatusId
    ,deleted.StartDate
    ,deleted.CaseName
    ,deleted.CaseRef
    ,deleted.BinderId
    ,deleted.BinderDescription
    ,deleted.BinderOwnerId
    ,deleted.SequentialRef
    ,deleted.ConcurrencyId
    ,deleted.AdviseCategoryId
    ,deleted.AdviceCaseId
    ,@StampActionUpdate
    ,@StampDateTime
    ,@StampUserId
    ,deleted.Owner2PartyId
    ,deleted.IsJoint
    ,deleted.ReopenDate
    ,deleted.StatusChangedOn
    ,deleted.Owner1Vulnerability
    ,deleted.Owner2Vulnerability
    ,deleted.Owner1VulnerabilityNotes
    ,deleted.Owner2VulnerabilityNotes
    ,deleted.ServicingAdminUserId
    ,deleted.ParaplannerUserId
    ,deleted.RecommendationId
    ,deleted.Owner1VulnerabilityId
    ,deleted.Owner2VulnerabilityId
    ,deleted.HasRisk
    ,deleted.ComplianceCompletedBy
    ,deleted.PropertiesJson
    INTO [dbo].[TAdviceCaseAudit](
               [CRMContactId]
              ,[PractitionerId]
              ,[StatusId]
              ,[StartDate]
              ,[CaseName]
              ,[CaseRef]
              ,[BinderId]
              ,[BinderDescription]
              ,[BinderOwnerId]
              ,[SequentialRef]
              ,[ConcurrencyId]
              ,[AdviseCategoryId]
              ,[AdviceCaseId]
              ,[StampAction]
              ,[StampDateTime]
              ,[StampUser]
              ,[Owner2PartyId]
              ,[IsJoint]
              ,[ReopenDate]
              ,[StatusChangedOn]
              ,[Owner1Vulnerability]
              ,[Owner2Vulnerability]
              ,[Owner1VulnerabilityNotes]
              ,[Owner2VulnerabilityNotes]
              ,[ServicingAdminUserId]
              ,[ParaplannerUserId]
              ,[RecommendationId]
              ,[Owner1VulnerabilityId]
              ,[Owner2VulnerabilityId]
              ,[HasRisk]
              ,[ComplianceCompletedBy]
              ,[PropertiesJson]
              )
    FROM [TAdviceCase] as AC
    JOIN #TempServiceCasesIds as SCI ON SCI.id = AC.AdviceCaseId

    DROP Table #TempServiceCasesIds

END

  EndProcedure:
GO
