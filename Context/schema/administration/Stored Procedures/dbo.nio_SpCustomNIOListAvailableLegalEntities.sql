SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [dbo].[nio_SpCustomNIOListAvailableLegalEntities]
	(
		@UserId bigint
	)

AS

DECLARE @LegalEntityId bigint
DECLARE @SuperUser bit
DECLARE @ViewAllLegalEntities bit
DECLARE @IndigoClientId bigint

SELECT @SuperUser = SuperUser | SuperViewer, @IndigoClientId = IndigoClientId
	FROM TUser WHERE UserId = @UserId

SELECT @LegalEntityId = GroupId 
	FROM dbo.FnGetLegalEntityForUser(@UserId)

SELECT @ViewAllLegalEntities = abs(isnull(PreferenceValue,1))
	FROM TLegalEntityPreference 
	WHERE GroupId = @LegalEntityId
	AND PreferenceName = 'ViewAllLegalEntities'

IF @SuperUser = 1 OR @ViewAllLegalEntities = 1
BEGIN
	SELECT
		T1.GroupId, 
		T1.Identifier,
		T1.GroupingId, 
		ISNULL(T1.ParentId, '') AS [ParentId], 
		ISNULL(T1.CRMContactId, '') AS [CRMContactId], 
		T1.IndigoClientId, 
		T1.LegalEntity AS [LegalEntity], 
		ISNULL(T1.GroupImageLocation, '') AS [GroupImageLocation], 
		ISNULL(T1.AcknowledgementsLocation, '') AS [AcknowledgementsLocation], 
		T1.FinancialYearEnd, 
		T1.ApplyFactFindBranding, 
		ISNULL(T1.VatRegNbr, '') AS [VatRegNbr], 
		ISNULL(T1.AuthorisationText, '') AS [AuthorisationText], 
		ISNULL(T1.FSARegNbr,'') as FSARegNbr,
		T1.ConcurrencyId,
		FrnNumber,
		IsFsaPassport,
		DocumentFileReference,
		MigrationRef,
		AdminEmail
	FROM TGroup T1

	WHERE (T1.IndigoClientId = @IndigoClientId) AND 
		(T1.LegalEntity = 1)

	ORDER BY T1.GroupId
	
END

ELSE

BEGIN
	SELECT
	T1.GroupId, 
	T1.Identifier,
	T1.GroupingId, 
	ISNULL(T1.ParentId, '') AS [ParentId], 
	ISNULL(T1.CRMContactId, '') AS [CRMContactId], 
	T1.IndigoClientId, 
	T1.LegalEntity AS [LegalEntity], 
	ISNULL(T1.GroupImageLocation, '') AS [GroupImageLocation], 
	ISNULL(T1.AcknowledgementsLocation, '') AS [AcknowledgementsLocation], 
	T1.FinancialYearEnd,
	T1.ApplyFactFindBranding, 
	ISNULL(T1.VatRegNbr, '') AS [VatRegNbr], 
	ISNULL(T1.AuthorisationText, '') AS [AuthorisationText], 
	ISNULL(T1.FSARegNbr,'') as FSARegNbr,
	T1.ConcurrencyId,
	FrnNumber,
	IsFsaPassport,
	DocumentFileReference,
	MigrationRef,
	AdminEmail	
	FROM TGroup T1

	WHERE T1.GroupId = @LegalEntityId
	ORDER BY T1.GroupId

END

GO
