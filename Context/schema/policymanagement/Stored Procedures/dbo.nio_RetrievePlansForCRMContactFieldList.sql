SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_RetrievePlansForCRMContactFieldList]
	 @CRMContactId bigint
AS 

	-- Exec nio_RetrievePlansForCRMContactFieldList @CRMContactId = 0

Select 
	0 As 'PlanId', 
	'' As 'SortId' , 
	'' As 'Number',
	'' As 'SellingPractitionerId', 
	'' As 'Status', 
	'' As 'ProductTypeId', 
	'' As 'RefPlanTypeId',
    '' As 'PlanTypeName', 
    '' As 'IsWrapperFg', 
    '' As 'WrapAllowOtherProvidersFg',
	'' As 'SippAllowOtherProvidersFg', 
	'' As 'IsWrapWrapper', 
	'' As 'IsNonWrapWrapper',
	'' As 'AdditionalOwnersFg', 
	'' As 'ProviderId', 
	'' As 'ProviderName',
    '' As 'PolicyBusinessId', 
    '' As 'PolicyDetailId', 
    '' As 'IsTopUp',
	'' As 'IsTopUpParent', 
	'' As 'ProdSubTypeName', 
	'' As 'ChangedToDate',
    '' As 'IsScheme', 
    '' As 'ExistingPolicy', 
    '' As 'SequentialRef', 
    '' As 'LinkedToSequentialRef', 
    '' As 'LinkedToPolicyBusinessId', 
    '' As 'AdviserFullName', 
	'' As 'LongName' , 
	'' As 'IsMortgage', 
	'' As 'CRMContactId',
	'' As 'AccountPartyId',
	'' As 'PolicyStartDate',
	'' As 'IsJointlyOwned',
	'' As 'ProductName'
	

GO
