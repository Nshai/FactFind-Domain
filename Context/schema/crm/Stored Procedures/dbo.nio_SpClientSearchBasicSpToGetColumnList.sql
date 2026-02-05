SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.nio_SpClientSearchBasicSpToGetColumnList
		@CorporateName VARCHAR(255) = NULL,
		@FirstName VARCHAR(255) = NULL,    
		@LastName VARCHAR(255) = NULL,
		@PolicyNumber VARCHAR(50) = NULL,
		@RefProdProviderId BIGINT = 0,    
		@ServicingAdviserPartyId BIGINT = 0,  
		@SequentialRefType varchar(50) = NULL,
		@SequentialRef varchar(50) = NULL,  
		@Postcode VARCHAR(10)= NULL,
		@_TenantId BIGINT,
		@_UserId BIGINT,    
		@_TopN INT = 0 
AS

/*
exec dbo.nio_SpClientSearchBasicSpToGetColumnList @_TenantId = 0, @_UserId = 0
*/

SELECT
	'' AS 'Owner 1.Id',
	'' AS 'Owner 1.Servicing Adviser.Full Name',
	'' AS 'Owner 1.Last Name',
	'' AS 'Owner 1.First Name',
	'' AS 'Owner 1.Corporate Name',
	'' as 'Id',
	'' AS 'Policy Number',
	'' AS 'Product Name',    
	'' AS 'Plan Type',
	'' AS 'Owner 1.Client Reference',
	'' AS 'Sequential Ref',
	--------------------------------------------------------------------------------------------
	-- The following lines have been commented out in the SDB search but may be needed for the backup search?
	--'' AS 'RightMask',
	--'' AS 'AdvancedMask',
	--------------------------------------------------------------------------------------------
	'' AS 'Owner 1.Client Secondary Reference',
	'' AS 'Plan Status',
	'' AS 'Owner 1.Client Type',
	'' AS 'Owner 1.Credited Group',
	'' AS 'Owner 1.Group',
	'' AS 'In Force Date',
	'' AS 'AdviceCaseName',
	'' AS 'AdviserGroupId',
	'' AS 'CreditedGroupId',
	'' AS 'GroupId',
	'' AS 'Fund',
	'' AS 'IncludeDeleted',
	0 AS 'PlanTypeId',
	'' AS 'PrimaryRef',
	'' AS 'ProductName',
	'' AS 'RefFundManager',
	'' AS 'SecondaryRef',
	'' AS 'SequentialRef',
	'' AS 'ServiceStatusId'

	-- Export
	, '' AS 'Owner 1.Title'
	, '' AS 'Owner 1.Address Line 1'
	, '' AS 'Owner 1.Address Line 2'
	, '' AS 'Owner 1.Address Line 3'
	, '' AS 'Owner 1.Address Line 4'
	, '' AS 'Owner 1.City / Town'
	, '' AS 'Owner 1.County'
	, '' AS 'Owner 1.Country'
	, '' AS 'Owner 1.PostCode'
	, '' AS 'Owner 1.Home Telephone Number'
	, '' AS 'Owner 1.Mobile Number'
	, '' AS 'Owner 1.Fax Number'
	, '' AS 'Owner 1.Email Address'
	, '' AS 'Owner 1.WebSite'
	, '' AS 'Provider.Name'
	, '' AS 'Plan Status Date'
GO
