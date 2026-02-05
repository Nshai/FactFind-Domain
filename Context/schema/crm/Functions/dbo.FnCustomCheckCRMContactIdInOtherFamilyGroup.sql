USE [crm]
GO
/****** Object:  UserDefinedFunction [dbo].[FnCustomGetCrmContactName]    Script Date: 13/12/2017 11:26:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FnCustomCheckCRMContactIdInOtherFamilyGroup]
	(@CrmContactId as BIGINT, @FamilyGroupCreationDate AS DATETIME, @TenantId INT)
	RETURNS INT
AS
BEGIN
	IF EXISTS
	(
	SELECT DISTINCT CRMContactId, B.IsHeadOfFamilyGroup, B.FamilyGroupCreationDate
	FROM CRM..TRelationship A
    JOIN TCRMContact B ON A.CRMContactToId=B.CRMContactId AND B.IndClientId = @TenantId AND B.ArchiveFg = 0
    JOIN TRefRelationshipType C ON A.RefRelTypeId =C.RefRelationshipTypeId
    JOIN TRefRelationshipType D ON A.RefRelCorrespondTypeId=D.RefRelationshipTypeId
	
	WHERE A.IsFamilyFg = 1 AND ISNULL(C.ArchiveFg, 0) = 0 AND (A.CRMContactFromId = @CRMContactId OR A.CRMContactToId = @CRMContactId) 
	AND b.FamilyGroupCreationDate IS NOT NULL AND B.IsHeadOfFamilyGroup = 1 AND FamilyGroupCreationDate < @FamilyGroupCreationDate
	)
	SET @CrmContactId = NULL
	
	RETURN @CrmContactId
END

