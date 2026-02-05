SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[SpCustomSearchIntroducersClientsAndUsers]
@IndClientId bigint,     
@FirstName varchar(255) = '', 
@LastName varchar(255) = '', 
@RefIntroducerTypeId bigint = 0,
@Identifier varchar(50) = '',
@_TopN int = 0
AS





BEGIN
	IF (@_TopN > 0) SET ROWCOUNT @_TopN


	SELECT
		1 AS Tag,
		NULL AS Parent,
		TContact.CRMContactId AS [Introducer!1!CRMContactId],
		CASE TContact.CRMContactType
			WHEN 1 THEN TContact.FirstName + ' ' + TContact.LastName
			ELSE TContact.CorporateName
		END AS [Introducer!1!ClientName],
		CASE 
			WHEN ISNULL(TIntro.IntroducerId, 0) > 0 THEN 'Introducer'
			WHEN ISNULL(TUser.UserId, 0) > 0 THEN 'User'
			ELSE 'Client'
		END AS [Introducer!1!Type],
		CASE 
			WHEN ISNULL(TIntro.IntroducerId, 0) > 0 THEN TIntroType.LongName
			ELSE 'n / a'
		END AS [Introducer!1!IntroducerType],
		ISNULL(TIntro.Identifier,'') AS [Introducer!1!Identifier]
	FROM 
		TCRMContact TContact
		LEFT JOIN TIntroducer TIntro ON TIntro.CRMContactId = TContact.CRMContactId
		LEFT JOIN Administration..TUser TUser ON TUser.CRMContactId = TContact.CRMContactId
		LEFT JOIN TRefIntroducerType TIntroType ON TIntroType.RefIntroducerTypeId = TIntro.RefIntroducerTypeId
		LEFT JOIN TPractitioner TPract ON TPract.CRMContactId = TContact.CRMContactId
	WHERE 
		((TContact.FirstName LIKE @FirstName + '%' OR TContact.CorporateName LIKE @FirstName + '%') OR @FirstName = '') AND
	    (TContact.LastName LIKE @LastName + '%' OR @LastName = '') AND
		(TIntro.RefIntroducerTypeId = @RefIntroducerTypeId OR @RefIntroducerTypeId = 0) AND
		ISNULL(TPract.PractitionerId, 0) = 0 AND (TIntro.Identifier LIKE @Identifier + '%' OR @Identifier = '')
		AND TContact.IndClientId = @IndClientId
	ORDER BY [Introducer!1!ClientName] Asc

	FOR XML EXPLICIT

	IF (@_TopN > 0) SET ROWCOUNT 0
END
GO
