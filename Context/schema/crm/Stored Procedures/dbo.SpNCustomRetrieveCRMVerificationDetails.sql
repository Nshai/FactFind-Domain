SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpNCustomRetrieveCRMVerificationDetails] @CRMContactId bigint

as

--Basic Data
select
Title, 
p.firstname as Forename,
middlename as MiddleName,
p.LastName as Surname,
case when GenderType not in ('Male','Female') then null else GenderType end as Gender,
cast(datepart(day,p.DOB) as varchar(2)) + '/' + cast(datepart(month,p.DOB) as varchar(2))+ '/' +  cast(datepart(year,p.DOB) as varchar(4)) as DOB,
datepart(day,p.DOB) as DOBDay,
datepart(month,p.DOB) as DOBMonth,
datepart(year,p.DOB) as DOBYear
from	CRM..TCRMContact c
inner join CRM..TPerson p on p.personid = c.personid
where c.CRMContactId = @CRMContactId

--Birth
select	
MothersMaidenName,
case when PlaceOfBirth in ('England','Wales') then 'ENGLANDWALES' when PlaceOfBirth = 'Other' then 'OTHER' else 'UNSPECIFIED' end as PlaceOfBirthURU,
PlaceOfBirth
from CRM..TVerification v
where v.CRMContactId = @CRMContactId

--Telephone
select	Value as Number
from	TContact c
where	c.CRMContactId = @CRMContactId and RefContactType = 'Telephone' and DefaultFg = 1

--Passport
select	 case when len(PassportRef) > 9 then PassportRef else null end as Number1,
case when CountryOfOrigin like 'UK %' then replace(CountryOfOrigin,'UK ', 'United Kingdom of Great Britain ') 
	 when CountryOfOrigin like 'UN %' then replace(CountryOfOrigin,'UN ', 'United Nations ') 
	 when CountryOfOrigin = 'UN Interim Admin. Mission in Kosovo (UNMIK)' then 'United Nations Interim Administration Mission in Kosovo (UNMIK)' 
else	CountryOfOrigin end as CountryOfOrigin,
cast(datepart(day,PassportExpiryDate) as varchar(2)) + '/' + cast(datepart(month,PassportExpiryDate) as varchar(2))+ '/' +  cast(datepart(year,PassportExpiryDate) as varchar(4)) as PassportExpiryDate,
datepart(day,PassportExpiryDate) as PassportExpiryDateDay,
datepart(month,PassportExpiryDate) as PassportExpiryDateMonth,
datepart(year,PassportExpiryDate) as PassportExpiryDateYear
from CRM..TVerification v
where v.CRMContactId = @CRMContactId

--Driving Licence Ref
select	 
case when len(DrivingLicenceRef) > 9 then DrivingLicenceRef else null end as Number1,
MicroficheNumber as Microfiche,
cast(datepart(day,v.MicroficheIssueDate) as varchar(2)) + '/' + cast(datepart(month,v.MicroficheIssueDate) as varchar(2))+ '/' +  cast(datepart(year,v.MicroficheIssueDate) as varchar(4)) as MicroficheIssueDate,
datepart(day,v.MicroficheIssueDate) as IssueDay,
datepart(month,v.MicroficheIssueDate) as IssueMonth,
datepart(year,v.MicroficheIssueDate) as IssueYear
from CRM..TVerification v
where v.CRMContactId = @CRMContactId

--Address Data - Current Home Address
--supplied in a fixed format
select  
datediff(year,a.residentfromdate,current_timestamp) as YrsAtAddress,
cast(datepart(day,a.residentfromdate) as varchar(2)) + '/' + cast(datepart(month,a.residentfromdate) as varchar(2))+ '/' +  cast(datepart(year,a.residentfromdate) as varchar(4)) as residentfromdate,
s.PostCode as Postcode,
addressline1,
addressline2,
addressline3,
addressline4,
CityTown,
CountyName,
a.addressid
from	TAddress a
inner join TAddressStore s on s.addressstoreid = a.addressstoreid
inner join TRefAddressStatus ras on ras.RefAddressStatusId = a.RefAddressStatusId
left outer join TRefCounty rc on rc.RefCountyId = s.RefCountyId
where	RefAddressTypeId = 1 and ras.AddressStatus = 'Current Address'
		and a.CRMContactId = @CRMContactId

declare @CurrentResidentFromDate Datetime
select @CurrentResidentFromDate = ResidentFromDate from	TAddress a
									inner join TAddressStore s on s.addressstoreid = a.addressstoreid
									inner join TRefAddressStatus ras on ras.RefAddressStatusId = a.RefAddressStatusId
									where	RefAddressTypeId = 1 and ras.AddressStatus = 'Current Address'
											and a.CRMContactId = @CRMContactId

--Address Data - 3 Previous Home Address(es) in the past 3 years
select distinct top 3 
datediff(year,a.residentfromdate,current_timestamp) as YrsAtAddress,
s.PostCode as Postcode,
addressline1,
addressline2,
addressline3,
addressline4,
CityTown,
CountyName,
a.addressid,
residentfromdate
from	TAddress a
inner join TAddressStore s on s.addressstoreid = a.addressstoreid
inner join TRefAddressStatus ras on ras.RefAddressStatusId = a.RefAddressStatusId
left outer join TRefCounty rc on rc.RefCountyId = s.RefCountyId
where	RefAddressTypeId = 1 and ras.AddressStatus = 'Previous Address'
		and a.CRMContactId = @CRMContactId
		and	
(a.ResidentFromDate > dateadd(year,-3,current_timestamp) 
or
(
	@CurrentResidentFromDate > dateadd(year,-3,current_timestamp) 
	and
	a.ResidentFromDate = (select max(a2.ResidentFromDate) from	TAddress a2
							inner join TAddressStore s on s.addressstoreid = a2.addressstoreid
							inner join TRefAddressStatus ras on ras.RefAddressStatusId = a2.RefAddressStatusId
							where	RefAddressTypeId = 1 and ras.AddressStatus = 'Previous Address'
									and a2.CRMContactId = @CRMContactId)
))
		

order by ResidentFromDate desc

--Electric
select	 
ElectricityBillRef
from CRM..TVerification v
where v.CRMContactId = @CRMContactId







GO
