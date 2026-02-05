SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [dbo].[spNCustomRetrieveFPTransactionReportClientDetails] @FinancialPlanningId bigint

as

--client contact phone number
declare @DefaultTelephone1 varchar(255), @DefaultTelephone2 varchar(255)


Select 
	@DefaultTelephone1 = value 
From 
	factfind..TFinancialPlanningSession fps WITH(NOLOCK)
	Inner Join factfind..TFactFind ff WITH(NOLOCK) on fps.FactFindId = ff.FactFindId
	Inner join crm..TContact c WITH(NOLOCK) on c.CRMContactId = ff.CRMContactId1
Where 
	fps.financialplanningid = @FinancialPlanningId
	And c.RefContactType = 'Telephone'
	And c.DefaultFg = 1

Select 
	@DefaultTelephone2 = value 
From 
	factfind..TFinancialPlanningSession fps WITH(NOLOCK)
	Inner Join factfind..TFactFind ff WITH(NOLOCK) on fps.FactFindId = ff.FactFindId
	Inner join crm..TContact c WITH(NOLOCK) on c.CRMContactId = ff.CRMContactId2
Where 
	fps.financialplanningid = @FinancialPlanningId
	And c.RefContactType = 'Telephone'
	And c.DefaultFg = 1


Select 
	Title, 
	FirstName, 
	LastName, 
	Case 
		When DOB is Null Then ''
		Else CONVERT(varchar(10), DOB, 103)
		End as DateOfBirth, 
	NINumber, 
	Telephone = @DefaultTelephone1,
	AddressLine1, 
	AddressLine2, 
	CityTown, 
	CountyName, 
	PostCode
From 
	factfind..TFinancialPlanningSession fps WITH(NOLOCK)
	Inner Join factfind..TFactFind ff WITH(NOLOCK) on fps.FactFindId = ff.FactFindId
	Inner Join crm..VPerson p WITH(NOLOCK) on ff.CRMContactId1 = p.CRMContactId
	Left Join crm..VwAddress a WITH(NOLOCK) on p.CRMContactId = a.CRMContactId and a.DefaultFg = 1
Where 
	fps.financialplanningid = @FinancialPlanningId

UNION ALL

Select 
	Title, 
	FirstName, 
	LastName, 
	Case 
		When DOB is Null Then ''
		Else CONVERT(varchar(10), DOB, 103)
		End as DateOfBirth, 
	NINumber, 
	--client contact phone number
	Telephone =  @DefaultTelephone2,
	AddressLine1, 
	AddressLine2, 
	CityTown, 
	CountyName, 
	PostCode
From 
	factfind..TFinancialPlanningSession fps WITH(NOLOCK)
	Inner Join factfind..TFactFind ff WITH(NOLOCK) on fps.FactFindId = ff.FactFindId
	Inner Join crm..VPerson p WITH(NOLOCK) on ff.CRMContactId2 = p.CRMContactId
	Left Join crm..VwAddress a WITH(NOLOCK) on p.CRMContactId = a.CRMContactId and a.DefaultFg = 1
Where 
	fps.financialplanningid = @FinancialPlanningId

GO
