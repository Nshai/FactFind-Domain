SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [dbo].[spCustomConfigureDefaultOrganisationData] 
	@IndigoClientId bigint, @TQCRoleId bigint, @AdviserRoleId bigint, @sIOProductType varchar(25)
AS



/******************************************************************************************************************************************************************************************************************
This is used to configure default set up scripts for IO modules.  Typically scripts which cannot be represented by an updategram are contained in here.

Scripts included

	1:>	PolicyManagement
	2:>	System Keys
	3:>	Report Keys
	4:>	Commissions Setup
	5:>	Campaign Management & Opportunity Management

******************************************************************************************************************************************************************************************************************/
-- lets do policymanagement first
declare @Sql varchar(255)

	Select @Sql='policymanagement..SpCustomInsertDefaultData' + @sIOProductType

	EXEC @Sql @IndigoClientId,@TQCRoleId,@AdviserRoleId

-- lets do System Keys

	EXEC SpCustomInsertDefaultSystemSecurityKeys @IndigoClientId

-- lets do the report keys

	EXEC SpCustomInsertDefaultReportsSecurityKeys @IndigoClientId

-- lets do the Commissions

	EXEC commissions..spCustomCommissionsConfig @IndigoClientId

-- lets do the Campaign Management & Opportunity Management

	EXEC CRM..SpCustomInsertDefaultDataForIndigoClient @IndigoClientId


GO
