USE [administration]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SpCustomGetTenantIdToRunDataScript]
      @RefTenantGroupName VARCHAR(150)
AS

If Exists( Select 1 From TIndigoClient
      Where Identifier = 'Stuart Cullinan Inc' And [Guid] = 'BF3F2538-8887-4DF9-8165-E2D810FE2C40' )
	Begin
      -- Local build
      Select 10155
	End
Else If Exists( Select 1 From TTenant2RefTenantGroup TG INNER JOIN TRefTenantGroup TR
			ON TG.RefTenantGroupId = TR.RefTenantGroupId Where TR.TenantGroupName LIKE @RefTenantGroupName) 
	Begin
      -- Return Tenants belonging to a certain group
		SELECT TG.TenantId
		FROM TTenant2RefTenantGroup TG 
		INNER JOIN TRefTenantGroup TR ON TG.RefTenantGroupId = TR.RefTenantGroupId
		WHERE TR.TenantGroupName LIKE @RefTenantGroupName
	End
Else If (@RefTenantGroupName LIKE 'ALL')
	BEGIN
		SELECT TG.TenantId
			FROM TTenant2RefTenantGroup TG 
			INNER JOIN TRefTenantGroup TR
			ON TG.RefTenantGroupId = TR.RefTenantGroupId Where TR.TenantGroupName IN('NBS', 'L&G')
	END

 