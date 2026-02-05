SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_RetrieveGroupSchemeMemberAndEmployeeDTOs]
    @GroupSchemeOwnerPartyId BIGINT,
	@GroupSchemeId BIGINT,
	@TenantId BIGINT,
	@PageSize INT,
	@PageNumber INT,
	@LastNameFilter VARCHAR(100) = '',
	@FirstNameFilter VARCHAR(100) = '',
	@SchemeCategoryNameFilter VARCHAR(100) = '',
	@SellingAdviserNameFilter VARCHAR(100) = '',
	@MembershipStatus INT = -1,
	@CurrentSort VARCHAR(20) = 'LastName'
AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	CREATE TABLE #schemeMembers
		(GroupSchemeId int, GroupSchemeMemberId int, JoiningDate datetime null, OwnerCRMContactId int INDEX IX_C CLUSTERED, PolicyBusinessId int null, 
			GroupSchemeCategoryId int null, IsLeaver bit, SchemeCategoryName nvarchar(100) NULL, TenantId INT, EmployeeCRMContactId int)

	INSERT INTO #schemeMembers
		SELECT GS.GroupSchemeId, GSM.GroupSchemeMemberId, GSM.JoiningDate, GS.OwnerCRMContactId,
			GSM.PolicyBusinessId, GSM.GroupSchemeCategoryId, GSM.IsLeaver, GSC.CategoryName, GSM.TenantId, GSM.CRMContactId
		FROM
			PolicyManagement..TGroupScheme GS
			JOIN Policymanagement..TGroupSchemeCategory GSC
				ON GSC.GroupSchemeId = GS.GroupSchemeId AND GS.GroupSchemeId = @GroupSchemeId
			JOIN PolicyManagement..TGroupSchemeMember GSM
				ON GSM.GroupSchemeCategoryId = GSC.GroupSchemeCategoryId
		WHERE
			GS.OwnerCRMContactId = @GroupSchemeOwnerPartyId
			AND GSM.TenantId = @TenantId
			AND
			(
				(@SchemeCategoryNameFilter = '')
				OR
				(@SchemeCategoryNameFilter != '' AND GSC.CategoryName LIKE @SchemeCategoryNameFilter+'%')
			)

	-- Change number to 1 based
	SET @PageNumber = @PageNumber + 1

	DECLARE @FirstRow INT, @LastRow INT
	SELECT	@FirstRow = (@PageNumber - 1) * @PageSize + 1,
			@LastRow = (@PageNumber - 1) * @PageSize + @PageSize;

	WITH PagedEmployees AS
	(
			SELECT PartyId, GroupSchemeMemberId, LastName, FirstName, EmployeeDateOfBirth,
				GroupSchemeOwnerPartyId, GroupSchemeId, IsSchemeMember, SchemeCategoryName,
				SellingAdviserName, AdviceTypeName, TenantId, IsClient, StatusName, JoiningDate,
				ROW_NUMBER() OVER
				(   ORDER BY
					CASE WHEN @CurrentSort = 'LastName' THEN LastName END ASC,
					CASE WHEN @CurrentSort = '-LastName' THEN LastName END DESC,
					CASE WHEN @CurrentSort = 'FirstName' THEN FirstName END ASC,
					CASE WHEN @CurrentSort = '-FirstName' THEN FirstName END DESC,
					CASE WHEN @CurrentSort = 'EmployeeDateOfBirth' THEN EmployeeDateOfBirth END ASC,
					CASE WHEN @CurrentSort = '-EmployeeDateOfBirth' THEN EmployeeDateOfBirth END DESC,
					CASE WHEN @CurrentSort = 'IsSchemeMember' THEN ISNULL(GroupSchemeMemberId,999999999) END ASC,
					CASE WHEN @CurrentSort = '-IsSchemeMember' THEN ISNULL(GroupSchemeMemberId,999999999) END DESC,
					CASE WHEN @CurrentSort = 'SchemeCategoryName' THEN ISNULL(SchemeCategoryName,'xxxxxxxxxxxxx') END ASC,
					CASE WHEN @CurrentSort = '-SchemeCategoryName' THEN ISNULL(SchemeCategoryName,'xxxxxxxxxxxxx') END DESC,
					CASE WHEN @CurrentSort = 'SellingAdviserName' THEN SellingAdviserName END ASC,
					CASE WHEN @CurrentSort = '-SellingAdviserName' THEN SellingAdviserName END DESC,
					CASE WHEN @CurrentSort = 'AdviceTypeName' THEN ISNULL(AdviceTypeName,'xxxxxxxxxxxxx') END ASC,
					CASE WHEN @CurrentSort = '-AdviceTypeName' THEN ISNULL(AdviceTypeName,'xxxxxxxxxxxxx') END DESC,
					CASE WHEN @CurrentSort = 'IsClient' THEN StatusName END ASC,
					CASE WHEN @CurrentSort = '-IsClient' THEN StatusName END DESC,
					CASE WHEN @CurrentSort = 'JoiningDate' THEN JoiningDate END ASC,
					CASE WHEN @CurrentSort = '-JoiningDate' THEN JoiningDate END DESC
				) AS RowNumber,
				count(*) OVER() AS TotalRowCount
			FROM
			(
				--GET SCHEME MEMBERS
				SELECT
					SM.EmployeeCRMContactId AS PartyId,
					SM.GroupSchemeMemberId,
					P.LastName AS LastName,
					P.FirstName AS FirstName,
					P.DOB AS EmployeeDateOfBirth,
					Employer.CRMContactId AS GroupSchemeOwnerPartyId,
					SM.GroupSchemeId,
					1 AS IsSchemeMember,
					SM.SchemeCategoryName,
					PractC.FirstName + ' ' + PractC.LastName AS SellingAdviserName,
					AT.Description AS AdviceTypeName,
					SM.TenantId,
					CASE WHEN contactStatus.StatusName like 'Client' THEN 1 ELSE 0 END as IsClient,
					contactStatus.StatusName,
					SM.JoiningDate
				FROM
					CRM..TCRMContact Employer
					JOIN #schemeMembers SM ON SM.OwnerCRMContactId = Employer.CRMContactId AND SM.IsLeaver = 0
					JOIN CRM..TCRMContact Employee ON Employee.CRMContactId = SM.EmployeeCRMContactId AND Employee.ArchiveFg = 0
					JOIN CRM..TPerson P ON P.PersonId = Employee.PersonId
					LEFT JOIN PolicyManagement..TPolicyBusiness PB ON PB.PolicyBusinessId = SM.PolicyBusinessId
					LEFT JOIN CRM..TPractitioner Pract ON Pract.PractitionerId = PB.PractitionerId
					LEFT JOIN CRM..TCRMContact PractC ON PractC.CRMContactId = Pract.CRMContactId
					LEFT JOIN PolicyManagement..TAdviceType AT ON AT.AdviceTypeId = PB.AdviceTypeId
					JOIN CRM..TRefCRMContactStatus contactStatus on contactStatus.RefCRMContactStatusId = Employee.RefCRMContactStatusId
				WHERE
					Employer.CRMContactId = @GroupSchemeOwnerPartyId
					AND (@MembershipStatus = 1 OR @MembershipStatus = -1)
					AND
					(
						(@LastNameFilter = '')
						OR
						(@LastNameFilter != '' AND P.LastName LIKE @LastNameFilter+'%')
					)
					AND
					(
						(@FirstNameFilter = '')
						OR
						(@FirstNameFilter != '' AND P.FirstName LIKE @FirstNameFilter+'%')
					)
					AND
					(
						(@SellingAdviserNameFilter = '')
						OR
						(@SellingAdviserNameFilter != '' AND PractC.FirstName+' '+PractC.LastName LIKE @SellingAdviserNameFilter+'%')
					)

			UNION ALL

				--GET RELATIONS
				SELECT
					Employee.CRMContactId AS PartyId,
					NULL AS GroupSchemeMemberId,
					P.LastName AS LastName,
					P.FirstName AS FirstName,
					P.DOB AS EmployeeDateOfBirth,
					@GroupSchemeOwnerPartyId AS GroupSchemeOwnerPartyId,
					NULL AS GroupSchemeId,
					0 AS IsSchemeMember,
					NULL AS SchemeCategoryName,
					NULL AS SellingAdviserName,
					NULL AS AdviceTypeName,
					Employer.IndClientId AS TenantId,
					CASE WHEN contactStatus.StatusName like 'Client' THEN 1 ELSE 0 END as IsClient,
					contactStatus.StatusName,
					NULL AS JoiningDate
				FROM
					CRM..TCRMContact Employer
					JOIN CRM..TRelationship R ON R.CRMContactFromId = Employer.CRMContactId
					JOIN CRM..TRefRelationshipType rt ON rt.RefRelationshipTypeId = R.RefRelCorrespondTypeId
					JOIN CRM..TCRMContact Employee ON Employee.CRMContactId = R.CRMContactToId AND Employee.ArchiveFg = 0
					JOIN CRM..TPerson P ON P.PersonId = Employee.PersonId
					JOIN CRM..TRefCRMContactStatus contactStatus on contactStatus.RefCRMContactStatusId = Employee.RefCRMContactStatusId
					LEFT JOIN #schemeMembers SM ON SM.EmployeeCRMContactId = Employee.CRMContactId
				WHERE
					SM.GroupSchemeMemberId IS NULL
					AND @SchemeCategoryNameFilter = ''
					AND @SellingAdviserNameFilter = ''
					AND (@MembershipStatus = 0 OR @MembershipStatus = -1)
					AND Employer.CRMContactId = @GroupSchemeOwnerPartyId
					AND Employer.IndClientId = @TenantId
					AND rt.RelationshipTypeName LIKE 'Employer%'
					AND
					(
						(@LastNameFilter = '')
						OR
						(@LastNameFilter != '' AND P.LastName LIKE @LastNameFilter+'%')
					)
					AND
					(
						(@FirstNameFilter = '')
						OR
						(@FirstNameFilter != '' AND P.FirstName LIKE @FirstNameFilter+'%')
					)
		) AS collected
	)
	SELECT PartyId,
		GroupSchemeMemberId,
		LastName,
		FirstName,
		EmployeeDateOfBirth,
		GroupSchemeOwnerPartyId,
		GroupSchemeId,
		IsSchemeMember,
		IsClient,
		SchemeCategoryName,
		SellingAdviserName,
		AdviceTypeName,
		TenantId,
		RowNumber,
		TotalRowCount,
		JoiningDate

	FROM PagedEmployees
	WHERE
		RowNumber BETWEEN @FirstRow AND @LastRow
		ORDER BY RowNumber ASC
GO
