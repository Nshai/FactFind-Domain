SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_Search_IntroducersClientsAndUsers]
	@UserId bigint,     
	@FirstName varchar(255) = null, 
	@LastNameOrCorporateName varchar(255) = null, 
	@RefIntroducerTypeId bigint = 0,
	@Identifier varchar(50) = null
AS
DECLARE @TenantId bigint
SELECT @TenantId = IndigoClientId FROM Administration..TUser WHERE UserId = @UserId

SELECT TOP 300		
	C.CRMContactId AS [CRMContactId],
	NULL AS [IntroducerId],      
	NULL AS [RefIntroducerTypeId],      
	NULL AS [IsArchived],      
	NULL AS [IsActive],      
	I.Identifier AS [Identifier],
	NULL AS [UniqueIdentifier],      
	NULL AS [ConcurrencyId],      
	ISNULL(IT.LongName, 'N / A') AS [IntroducerTypeLongName],      
	NULL AS [IntroducerTypeCanReceiveRenewals],      
	NULL AS [IntroducerTypeDefaultSplitPercentage],      
	CASE C.CRMContactType
		WHEN 1 THEN C.FirstName + ' ' + C.LastName
		ELSE C.CorporateName
	END AS [IntroducerName],
	NULL AS [CRMContactType],      
	NULL AS [AssignedAdviserId],      
	NULL AS [AssignedAdviserFullName],    
	NULL AS UserFullName,    
	NULL AS UserName,    
	NULL AS UserStatusDisplay,  
	NULL AS BranchNameDisplay ,
	NULL AS UserEmail,
	NULL AS UserRole,
	NULL AS AssociatedGroups,
	CASE 
		WHEN I.IntroducerId IS NOT NULL THEN 'Introducer'
		WHEN U.UserId IS NOT NULL THEN 'User'
		ELSE 'Client'
	END AS [IntroducerClientOrUser]
FROM 
	TCRMContact C
	LEFT JOIN TIntroducer I ON I.CRMContactId = C.CRMContactId
	LEFT JOIN Administration..TUser U ON U.CRMContactId = C.CRMContactId
	LEFT JOIN TRefIntroducerType IT ON IT.RefIntroducerTypeId = I.RefIntroducerTypeId
	LEFT JOIN TPractitioner A ON A.CRMContactId = C.CRMContactId
WHERE 
	C.IndClientId = @TenantId
	AND A.PractitionerId IS NULL 
	AND (C.FirstName LIKE @FirstName OR @FirstName IS NULL)
    AND (C.LastName LIKE @LastNameOrCorporateName OR C.CorporateName LIKE @LastNameOrCorporateName OR @LastNameOrCorporateName IS NULL)
	AND (I.RefIntroducerTypeId = @RefIntroducerTypeId OR @RefIntroducerTypeId = 0)
	AND (I.Identifier LIKE @Identifier OR @Identifier IS NULL)
GO
