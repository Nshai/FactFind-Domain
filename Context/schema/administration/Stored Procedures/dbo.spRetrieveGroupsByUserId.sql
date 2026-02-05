USE [administration]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spRetrieveGroupsByUserId]
	@UserId BIGINT
AS

IF OBJECT_ID('tempdb..#UserGroup') IS NOT NULL DROP TABLE #UserGroup
CREATE TABLE #UserGroup
(
	GroupId BIGINT,
	Identifier VARCHAR(64),
	GroupingId INT,
	ParentId INT,
	CRMContactId INT,
	IndigoClientId INT,
	LegalEntity BIT,
	AcknowledgementsLocation VARCHAR(500),
	FinancialYearEnd DATETIME,
	ApplyFactFindBranding BIT,
	VatRegNbr VARCHAR(50),
	FSARegNbr VARCHAR(24),
	AuthorisationText VARCHAR(500),
	ConcurrencyId INT,
	IsFSAPassport BIT,
	FRNNumber VARCHAR(10),
	DocumentFileReference VARCHAR(100),
	MigrationRef VARCHAR(255),
	AdminEmail VARCHAR(128) 
)

CREATE NONCLUSTERED INDEX IDX_GroupId ON #UserGroup(GroupId);
CREATE NONCLUSTERED INDEX IDX_ParentId ON #UserGroup(ParentId);
 
INSERT INTO #UserGroup
SELECT 
	g.GroupId,
	g.Identifier,
	g.GroupingId,
	g.ParentId,
	g.CRMContactId,
	g.IndigoClientId,
	g.LegalEntity,
	g.AcknowledgementsLocation ,
	g.FinancialYearEnd,
	g.ApplyFactFindBranding,
	g.VatRegNbr,
	g.FSARegNbr,
	g.AuthorisationText,
	g.ConcurrencyId,
	g.IsFSAPassport,
	g.FRNNumber,
	g.DocumentFileReference,
	g.MigrationRef,
	g.AdminEmail 
FROM Administration.dbo.TGroup g
join Administration.dbo.TUser u on u.IndigoClientId = g.IndigoClientId
WHERE u.UserId = @UserId

;WITH ParentGroup(GroupId, Identifier, GroupingId, ParentId, CRMContactId, IndigoClientId,
					LegalEntity, AcknowledgementsLocation, FinancialYearEnd, ApplyFactFindBranding,
					VatRegNbr, FSARegNbr, AuthorisationText, ConcurrencyId, IsFSAPassport,
					FRNNumber, DocumentFileReference, MigrationRef, AdminEmail)
AS
(
 SELECT ug.*
 FROM #UserGroup ug
 join Administration.dbo.TUser u on u.IndigoClientId = ug.IndigoClientId
 WHERE ug.GroupId = u.GroupId 
 AND u.UserId = @UserId
 ),

RecursiveQuery(GroupId, Identifier, GroupingId, ParentId, CRMContactId, IndigoClientId,
					LegalEntity, AcknowledgementsLocation, FinancialYearEnd, ApplyFactFindBranding,
					VatRegNbr, FSARegNbr, AuthorisationText, ConcurrencyId, IsFSAPassport,
					FRNNumber, DocumentFileReference, MigrationRef, AdminEmail)
AS
(
 SELECT pg.*
 From ParentGroup pg
 UNION ALL
 SELECT ug.*
 FROM #UserGroup ug
 JOIN RecursiveQuery rec ON ug.ParentID = rec.GroupId
)

SELECT 
	GroupId,
	Identifier,
	GroupingId,
	ParentId,
	CRMContactId,
	IndigoClientId,
	LegalEntity,
	DocumentFileReference,
	AcknowledgementsLocation, 
	FinancialYearEnd, 
	ApplyFactFindBranding,
	VatRegNbr,
	FSARegNbr, 
	AuthorisationText, 
	ConcurrencyId, 
	IsFSAPassport,
	FRNNumber, 
	DocumentFileReference, 
	MigrationRef, 
	AdminEmail
FROM RecursiveQuery