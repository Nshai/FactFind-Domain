SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_RetrieveGroupSchemeMembersForExport]
    @GroupSchemeOwnerPartyId BIGINT,
	@GroupSchemeId BIGINT,
	@TenantId BIGINT
AS

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    CREATE TABLE #schemeMembers
    (   GroupSchemeId int, GroupSchemeMemberId int, JoiningDate datetime null, LeavingDate datetime null,
        OwnerCRMContactId int INDEX IX_C CLUSTERED, PolicyBusinessId int null,
        GroupSchemeCategoryId int null, IsLeaver bit, CategoryName nvarchar(100) NULL, TenantId INT, EmployeeCRMContactId int,
        ContributionAmount money null, SchemeName varchar(50) null, SchemeNumber varchar(50) null,
        EmployeeContribution money null, EmployerContribution money null,
        SequentialRef varchar(50) null, PolicyNumber varchar(50) null, ProviderName varchar(255) null,
        PensionableSalary money null, SelectedRetirementAge int null
    )

    INSERT INTO #schemeMembers
	    SELECT GS.GroupSchemeId, GSM.GroupSchemeMemberId, GSM.JoiningDate, GSM.LeavingDate,
            GS.OwnerCRMContactId, GSM.PolicyBusinessId,
            GSM.GroupSchemeCategoryId, GSM.IsLeaver, GSC.CategoryName, GSM.TenantId, GSM.CRMContactId,
            GS.ContributionAmount, GS.SchemeName, GS.SchemeNumber,
            GSC.EmployeeContribution, GSC.EmployerContribution,
            VPB.SequentialRef, VPB.PolicyNumber, VPB.ProviderName,
            PInfo.PensionableSalary, PInfo.SelectedRetirementAge
	    FROM
            PolicyManagement..TGroupScheme GS
            JOIN Policymanagement..TGroupSchemeCategory GSC
                ON GSC.GroupSchemeId = GS.GroupSchemeId AND GS.GroupSchemeId = @GroupSchemeId
            JOIN PolicyManagement..TGroupSchemeMember GSM
                ON GSM.GroupSchemeCategoryId = GSC.GroupSchemeCategoryId
            JOIN PolicyManagement..VPolicyBusinessDTO VPB
                ON VPB.PolicyBusinessId = GSM.PolicyBusinessId
            LEFT JOIN PolicyManagement..TPensionInfo PInfo
                ON PInfo.PolicyBusinessId = VPB.PolicyBusinessId
	    WHERE
            GS.OwnerCRMContactId = @GroupSchemeOwnerPartyId
		    AND GSM.TenantId = @TenantId
            AND GS.GroupSchemeId = @GroupSchemeId

    --GET SCHEME MEMBERS
    SELECT
        P.FirstName AS FirstName,
        P.LastName AS LastName,
        Employee.ExternalReference AS ClientRef,
        Employee.CRMContactId AS ClientCRMContactId,
        P.NINumber AS NINumber,
        SM.SequentialRef As PlanRef,
        P.DOB AS DateOfBirth,
        SM.PensionableSalary AS PensionableSalary,
        SM.EmployeeContribution AS EmployeeContribution,
        SM.EmployerContribution AS EmployerContribution,
        SM.ContributionAmount AS ContributionPremium,
        SM.SchemeName AS SchemeName,
        SM.SchemeNumber AS SchemeNumber,
        SM.PolicyNumber AS PolicyNumber,
        SM.ProviderName AS ProviderName,
        SM.JoiningDate AS StartDate,
        SM.LeavingDate AS LeavingDate,
        SM.CategoryName AS CategoryName,
        SM.SelectedRetirementAge AS StandardRetirementAge,
        CAST(1 As bit) AS IsSchemeMember,
        SM.IsLeaver AS IsLeaver,
        CASE WHEN contactStatus.StatusName like 'Client' THEN CAST(1 As bit) ELSE CAST(0 As bit) END as IsClient
    FROM
        CRM..TCRMContact Employer
        JOIN #schemeMembers SM ON SM.OwnerCRMContactId = Employer.CRMContactId
        JOIN CRM..TCRMContact Employee ON Employee.CRMContactId = SM.EmployeeCRMContactId AND Employee.ArchiveFg = 0
        JOIN CRM..TPerson P ON P.PersonId = Employee.PersonId
        JOIN CRM..TRefCRMContactStatus contactStatus on contactStatus.RefCRMContactStatusId = Employee.RefCRMContactStatusId
    WHERE
        Employer.CRMContactId = @GroupSchemeOwnerPartyId

    UNION ALL

    --GET RELATIONS
    SELECT
        P.FirstName AS FirstName,
        P.LastName AS LastName,
        Employee.ExternalReference AS ClientRef,
        Employee.CRMContactId AS ClientCRMContactId,
        P.NINumber AS NINumber,
        NULL As PlanRef,
        P.DOB AS DateOfBirth,
        NULL AS PensionableSalary,
        NULL AS EmployeeContribution,
        NULL AS EmployerContribution,
        TGS.ContributionAmount AS ContributionPremium,
        TGS.SchemeName AS SchemeName,
        TGS.SchemeNumber AS SchemeNumber,
        NULL AS PolicyNumber,
        NULL AS ProviderName,
        NULL AS StartDate,
        NULL AS LeavingDate,
        NULL AS CategoryName,
        NULL AS StandardRetirementAge,
        CAST(0 As bit) AS IsSchemeMember,
        NULL AS IsLeaver,
        CASE WHEN contactStatus.StatusName like 'Client' THEN CAST(1 As bit) ELSE CAST(0 As bit) END as IsClient
    FROM
        CRM..TCRMContact Employer
        JOIN CRM..TRelationship R ON R.CRMContactFromId = Employer.CRMContactId
        JOIN CRM..TRefRelationshipType rt ON rt.RefRelationshipTypeId = R.RefRelCorrespondTypeId
        JOIN CRM..TCRMContact Employee ON Employee.CRMContactId = R.CRMContactToId AND Employee.ArchiveFg = 0
        JOIN CRM..TPerson P ON P.PersonId = Employee.PersonId
        JOIN CRM..TRefCRMContactStatus contactStatus on contactStatus.RefCRMContactStatusId = Employee.RefCRMContactStatusId
        JOIN PolicyManagement..TGroupScheme TGS ON TGS.OwnerCRMContactId = Employer.CRMContactId AND TGS.GroupSchemeId = @GroupSchemeId
        LEFT JOIN #schemeMembers SM ON SM.EmployeeCRMContactId = Employee.CRMContactId
    WHERE
        SM.GroupSchemeMemberId IS NULL
        AND Employer.CRMContactId = @GroupSchemeOwnerPartyId
        AND Employer.IndClientId = @TenantId
        AND rt.RelationshipTypeName LIKE 'Employer%'
GO
