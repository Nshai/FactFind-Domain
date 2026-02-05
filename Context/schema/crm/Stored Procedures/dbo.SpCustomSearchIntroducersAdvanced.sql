SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomSearchIntroducersAdvanced]
--	@IndClientId BIGINT,     
	@UserId BIGINT,
	@FirstName VARCHAR(255) = '%', 
	@LastNameOrCorporateName VARCHAR(255) = '%', 
	@RefIntroducerTypeId  BIGINT=-1,
	@ArchiveFg BIGINT= -1, 
	@PractitionerId BIGINT = 0,
	@Identifier VARCHAR(50) = '%'

AS

if @FirstName <> '%'
	Select @FirstName = @FirstName + '%'

if @LastNameOrCorporateName <> '%'
	Select @LastNameOrCorporateName = @LastNameOrCorporateName + '%'

if @Identifier <> '%'
	Select @Identifier = @Identifier + '%'

Declare @IndigoClientId Bigint, @GroupId Bigint
Select @IndigoClientId = IndigoClientId, @GroupId = GroupId  
From Administration.dbo.TUser 
Where UserId = @UserId


BEGIN
	SELECT
		1 AS Tag,
		NULL AS Parent,
		A.IntroducerId AS [Introducer!1!IntroducerId],
		A.CRMContactId AS [Introducer!1!CRMContactId],
		A.RefIntroducerTypeId AS [Introducer!1!RefIntroducerTypeId],
		A.ArchiveFg AS [Introducer!1!ArchiveFg],
		A.Identifier AS [Introducer!1!Identifier],
		ISNULL(A.[UniqueIdentifier],'') AS [Introducer!1!UniqueIdentifier],
		A.ConcurrencyId AS [Introducer!1!ConcurrencyId],
		B.LongName AS [Introducer!1!LongName],
		B.RenewalsFG AS [Introducer!1!RenewalsFG],
		B.DefaultSplit AS [Introducer!1!DefaultSplit],
		Case When ISNULL(C.CRMContactType,0) = 1 then
			ISNULL(C.FirstName,'') + ' ' + ISNULL(C.LastName,'')
		Else
			ISNULL(C.CorporateName,'') 
		End AS [Introducer!1!IntroducerName],
		ISNULL(C.CRMContactType,0) AS [Introducer!1!CRMContactType],
		A.PractitionerId AS [Introducer!1!PractitionerId],
		ISNULL(E.FirstName,'')  + ' ' + ISNULL(E.LastName,'') AS [Introducer!1!PractFullName]

	FROM TIntroducer A
	
	INNER JOIN TRefIntroducerType B ON A.RefIntroducerTypeId = B.RefIntroducerTypeId
	INNER JOIN TCRMContact C ON A.CRMContactId = C.CRMContactId
	LEFT JOIN TPractitioner D ON D.PractitionerId = A.PractitionerId
	LEFT JOIN TCRMContact E ON E.CRMContactId = D.CRMContactId

-- 	INNER JOIN (
-- 		Select A.IntroducerId, B.GroupId
-- 		From CRM.dbo.TIntroducerGroup A
-- 		Inner Join Administration.dbo.TGroup B on A.GroupId = B.GroupId
-- 		Inner Join Administration.dbo.TUser C on C.GroupId = B.GroupId
-- 		Where 1=1 
-- 			And C.UserId = @UserId  
-- 			And C.IndigoClientid = @IndigoClientId
-- 			And A.GroupId = @GroupId
-- 		) F On F.IntroducerId = A.IntroducerId

	INNER JOIN dbo.TIntroducerGroup F
		On F.IntroducerId = A.IntroducerId And F.GroupId = @GroupId
	WHERE 1=1
		And A.IndClientid = @IndigoClientId
		And  IsNull(C.FirstName,'') Like @FirstName --AND IsNull(C.CorporateName,'') = ''
		-- AND ((IsNull(C.LastName,'') Like @LastNameOrCorporateName) OR (IsNull(C.CorporateName,'') Like @LastNameOrCorporateName))
		AND IsNull(C.LastName,'') + IsNull(C.CorporateName,'') Like @LastNameOrCorporateName
		AND IsNull(A.Identifier,'') LIKE @Identifier
		AND ( (A.RefIntroducerTypeId = @RefIntroducerTypeId) OR (@RefIntroducerTypeId = -1) )
		AND ( (A.ArchiveFG = @ArchiveFg  AND @ArchiveFg <> -1) OR (@ArchiveFg = -1 ) )

	FOR XML EXPLICIT

END
GO
