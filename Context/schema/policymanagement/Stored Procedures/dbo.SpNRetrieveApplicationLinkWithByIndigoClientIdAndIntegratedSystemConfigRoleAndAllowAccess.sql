SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveApplicationLinkWithByIndigoClientIdAndIntegratedSystemConfigRoleAndAllowAccess]
	@IndigoClientId bigint,
	@IntegratedSystemConfigRole int,
	@AllowAccess bit
AS

/*
Note:
This is called in OpenIndigoNet svn project
Intelliflo.OpenIndigo.Data.AdministrationData
It is consumed in Intelliflo.OpenIndigo.Data.FactFindData.ApplyPostcodeLookupPreference(..)
This was done because we now have more than one postcode provider and it is a microservice
*/

-- exec policymanagement..SpNRetrieveApplicationLinkWithByIndigoClientIdAndIntegratedSystemConfigRoleAndAllowAccess @IntegratedSystemConfigRole=4,@IndigoClientId=10155,@AllowAccess=1

select 'Dummy' as [UserName], 'Dummy' as [Password]

/*
Select * 
From PolicyManagement.dbo.TApplicationLink As [ApplicationLink]
Inner Join PolicyManagement.dbo.TAddressLookupConfig As [AddressLookupConfig]
	On [ApplicationLink].ApplicationLinkId = [AddressLookupConfig].RefApplicationLinkId
Where [ApplicationLink].IndigoClientId = @IndigoClientId And [ApplicationLink].IntegratedSystemConfigRole = @IntegratedSystemConfigRole And [ApplicationLink].AllowAccess = @AllowAccess
*/
GO
