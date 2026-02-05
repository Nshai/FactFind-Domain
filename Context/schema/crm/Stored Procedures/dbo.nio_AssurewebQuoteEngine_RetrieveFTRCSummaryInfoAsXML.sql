SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.nio_AssurewebQuoteEngine_RetrieveFTRCSummaryInfoAsXML 
@AdviserCRMId bigint, 
@ClientCRMId1 bigint, 
@ClientCRMId2 bigint  

AS  
  
/*
LIO SP: SpNCustomRetrieveQuoteSummaryInfoAsXML

Info: used to submit client details for extranet linking
*/
  
--test  
--declare @AdviserCRMId bigint, @ClientCRMId1 bigint, @ClientCRMId2 bigint  
--Set @AdviserCRMId = 2306  
--Set @ClientCRMId1 = 1327273  
--Set @ClientCRMId2 = 0  
  
--internal params  
declare @IndigoClientId bigint  
  
  
Select @IndigoClientId = IndigoClientId   
From  Administration..TUser  
Where CRMContactId = @AdviserCRMId  
  
Select    
 1 AS Tag,    
 NULL AS Parent,    
  
 Null AS [Details!1!], --Root  
  
 --Firm  
 Null AS [Data!2!IndigoClientId],  
 Null AS [Data!2!Identifier],  
 Null AS [Data!2!FirmId],  
 Null AS [Data!2!FirmAddressLine1],  
 Null AS [Data!2!FirmAddressLine2],  
 Null AS [Data!2!FirmAddressLine3],  
 Null AS [Data!2!FirmAddressLine4],  
 Null AS [Data!2!FirmCityTown],  
 Null AS [Data!2!FirmCountyName],  
 Null AS [Data!2!FirmCountryName],  
 Null AS [Data!2!FirmEmailAddress],  
 Null AS [Data!2!FirmPostCode],  
  
 --Adviser  
 Null AS [Data!2!AdviserReference],  
 Null AS [Data!2!AdviserName],  
 Null AS [Data!2!AdviserTelephone],  
 Null AS [Data!2!AdviserMobile],  
 Null AS [Data!2!AdviserEmail],  
 Null AS [Data!2!AdviserFax],  
  
 --Client  
 Null AS [Data!2!ClientCRMId],  
 Null AS [Data!2!ICRNe],  
 Null AS [Data!2!ClientAddressLine1],  
 Null AS [Data!2!ClientAddressLine2],  
 Null AS [Data!2!ClientAddressLine3],  
 Null AS [Data!2!ClientAddressLine4],  
 Null AS [Data!2!ClientCityTown],  
 Null AS [Data!2!ClientCountyName],  
 Null AS [Data!2!ClientCountryName],  
 Null AS [Data!2!ClientPostCode],  
 Null AS [Data!2!ClientAddressType],  
 Null AS [Data!2!ClientTelephone],  
 Null AS [Data!2!ClientMobile],  
 Null AS [Data!2!ClientEmail],  
 Null AS [Data!2!ClientFax],  
  
 Null AS [Data!2!NINumber],  
 Null AS [Data!2!UKResident],  
 Null AS [Data!2!ResidentIn],  
 Null AS [Data!2!MaritalStatus],  
  
 --Bank  
 Null AS [Data!2!BankName],  
 Null AS [Data!2!BankAccountHolders],  
 Null AS [Data!2!BankAccountName],  
 Null AS [Data!2!BankAddressLine1],  
 Null AS [Data!2!BankAddressLine2],  
 Null AS [Data!2!BankAddressLine3],  
 Null AS [Data!2!BankAddressLine4],  
 Null AS [Data!2!BankCityTown],  
 Null AS [Data!2!BankCountyName],  
 Null AS [Data!2!BankCountryName],  
 Null AS [Data!2!BankPostCode],  
 Null AS [Data!2!BankAccountNumber],  
 Null AS [Data!2!BankSortCode],  
  
 --Employment  
 Null AS [Data!2!EmploymentStatus],  
 Null AS [Data!2!Employer],  
 Null AS [Data!2!Occupation],  
 Null AS [Data!2!OccupationCode],  
  
 --Professional Contact - Dr info  
 Null AS [Data!2!DoctorsName],  
 Null AS [Data!2!SurgeryName],  
 Null AS [Data!2!SurgeryAddressLine1],  
 Null AS [Data!2!SurgeryAddressLine2],  
 Null AS [Data!2!SurgeryAddressLine3],  
 Null AS [Data!2!SurgeryAddressLine4],  
 Null AS [Data!2!SurgeryCityTown],  
 Null AS [Data!2!SurgeryCountyName],  
 Null AS [Data!2!SurgeryPostCode],  
 Null AS [Data!2!SurgeryPhoneNo]  
  
UNION ALL  
  
--Firm & Client & Bank & Employment & Professional Contact details for client1  
Select  
 2 As Tag,  
 1 As Parent,  
  
 Null, --Root  
  
 --Firm  
 TIC.IndigoClientId AS [Data!2!IndigoClientId],  
 TIC.Identifier AS [Data!2!Identifier],  
 Case When IsNull(TIC.FSA,'') <> '' Then IsNull(TIC.FSA,'') Else IsNull(TIC.SIB,'') End AS [Data!2!FirmId],  
 IsNull(TIC.AddressLine1,'') AS [Data!2!FirmAddressLine1],  
 IsNull(TIC.AddressLine2,'') AS [Data!2!FirmAddressLine2],  
 IsNull(TIC.AddressLine3,'') AS [Data!2!FirmAddressLine3],  
 IsNull(TIC.AddressLine4,'') AS [Data!2!FirmAddressLine4],  
 IsNull(TIC.CityTown,'') AS [Data!2!FirmCityTown],  
 IsNull(ICCounty.CountyName,'') AS [Data!2!FirmCountyName],  
 IsNull(ICCountry.CountryName,'') AS [Data!2!FirmCountryName],  
 IsNull(TIC.EmailAddress,'') AS [Data!2!FirmEmailAddress],  
 IsNull(TIC.Postcode,'') AS [Data!2!FirmPostCode],  
  
 --Adviser  
 IsNull(K.FSAReference,'') AS [Data!2!AdviserReference],  
 IsNull(KName.FirstName + ' ' + KName.LastName,'') AS [Data!2!AdviserName],  
 IsNull(APhone.Value,'') AS [Data!2!AdviserTelephone],  
 IsNull(AMobile.Value,'') AS [Data!2!AdviserMobile],  
 IsNull(AEMail.Value,'') AS [Data!2!AdviserEmail],  
 IsNull(AFax.Value,'') AS [Data!2!AdviserFax],  
  
 --Client  
 IsNull(A.CRMContactId,0) AS [Data!2!ClientCRMId],  
 IsNull(A.ExternalReference,'') AS [Data!2!ICRNe],  
 IsNull(C.AddressLine1,'') AS [Data!2!ClientAddressLine1],  
 IsNull(C.AddressLine2,'') AS [Data!2!ClientAddressLine2],  
 IsNull(C.AddressLine3,'') AS [Data!2!ClientAddressLine3],  
 IsNull(C.AddressLine4,'') AS [Data!2!ClientAddressLine4],  
 IsNull(C.CityTown,'') AS [Data!2!ClientCityTown],  
 IsNull(D.CountyName,'') AS [Data!2!ClientCountyName],  
 IsNull(E.CountryName,'') AS [Data!2!ClientCountryName],  
 IsNull(C.Postcode,'') AS [Data!2!ClientPostCode],  
 IsNull(B.AddressTypeName,'') AS [Data!2!ClientAddressType],  
 IsNull(CPhone.Value,'') AS [Data!2!ClientTelephone],  
 IsNull(CMobile.Value,'') AS [Data!2!ClientMobile],  
 IsNull(CEMail.Value,'') AS [Data!2!ClientEmail],  
 IsNull(CFax.Value,'') AS [Data!2!ClientFax],  
  
 IsNull(CPerson.NINumber,'') AS [Data!2!NINumber],  
 IsNull(CPerson.UKResident,0) AS [Data!2!UKResident],  
 IsNull(CPerson.ResidentIn,'') AS [Data!2!ResidentIn],  
 IsNull(CPerson.MaritalStatus,'') AS [Data!2!MaritalStatus],  
  
 --Bank  
 IsNull(F.BankName,'') AS [Data!2!BankName],  
 IsNull(F.AccountHolders,'') AS [Data!2!BankAccountHolders],  
 IsNull(F.AccountName,'') AS [Data!2!BankAccountName],  
 IsNull(F.AddressLine1,'') AS [Data!2!BankAddressLine1],  
 IsNull(F.AddressLine2,'') AS [Data!2!BankAddressLine2],  
 IsNull(F.AddressLine3,'') AS [Data!2!BankAddressLine3],  
 IsNull(F.AddressLine4,'') AS [Data!2!BankAddressLine4],  
 IsNull(F.CityTown,'') AS [Data!2!BankCityTown],  
 IsNull(H.CountyName,'') AS [Data!2!BankCountyName],  
 IsNull(J.CountryName,'') AS [Data!2!BankCountryName],  
 IsNull(F.Postcode,'') AS [Data!2!BankPostCode],  
 IsNull(F.AccountNumber,'') AS [Data!2!BankAccountNumber],  
 IsNull(F.SortCode,'') AS [Data!2!BankSortCode],  
  
 --Employment  
 IsNull(L.EmploymentStatus,'') AS [Data!2!EmploymentStatus],  
 IsNull(L.Employer,'') AS [Data!2!Employer],  
 IsNull(M.Description,'Unknown Occupation (assumed non-hazardous for quotation)') AS [Data!2!Occupation],  
 IsNull(M.OrigoCode,'') AS [Data!2!OccupationCode],  
  
 --Professional Contact - Dr info  
 IsNull(N.ContactName,'') AS [Data!2!DoctorsName],  
 IsNull(N.CompanyName,'') AS [Data!2!SurgeryName],  
 IsNull(N.AddressLine1,'') AS [Data!2!SurgeryAddressLine1],  
 IsNull(N.AddressLine2,'') AS [Data!2!SurgeryAddressLine2],  
 IsNull(N.AddressLine3,'') AS [Data!2!SurgeryAddressLine3],  
 IsNull(N.AddressLine4,'') AS [Data!2!SurgeryAddressLine4],  
 IsNull(N.CityTown,'') AS [Data!2!SurgeryCityTown],  
 IsNull(N.County,'') AS [Data!2!SurgeryCountyName],  
 IsNull(N.Postcode,'') AS [Data!2!SurgeryPostCode],  
 IsNull(N.TelephoneNumber,'') AS [Data!2!SurgeryPhoneNo]  
  
From CRM..TCRMContact A WITH(NOLOCK)  
 Left Join CRM..TAddress B WITH(NOLOCK) On A.CRMContactId = B.CRMContactId And B.DefaultFg = 1  
 Left Join CRM..TAddressStore C WITH(NOLOCK) On B.AddressStoreId = C.AddressStoreId  
   
 Left Join CRM..TRefCounty D WITH(NOLOCK) On C.RefCountyId = D.RefCountyId  
 Left Join CRM..TRefCountry E WITH(NOLOCK) On C.RefCountryId = E.RefCountryId  
  
 --Client Contacts  
 Left Join CRM..TContact CPhone WITH(NOLOCK) On CPhone.CRMContactId = A.CRMContactId And CPhone.RefContactType = 'Telephone' And CPhone.DefaultFg = 1  
 Left Join CRM..TContact CMobile WITH(NOLOCK) On CMobile.CRMContactId = A.CRMContactId And CMobile.RefContactType = 'Mobile' And CMobile.DefaultFg = 1  
 Left Join CRM..TContact CEMail WITH(NOLOCK) On CEMail.CRMContactId = A.CRMContactId And CEMail.RefContactType = 'E-Mail' And CEMail.DefaultFg = 1  
 Left Join CRM..TContact CFax WITH(NOLOCK) On CFax.CRMContactId = A.CRMContactId And CFax.RefContactType = 'Fax' And CFax.DefaultFg = 1  
  
 --Person Details  
 Left Join CRM..TPerson CPerson WITH(NOLOCK) On CPerson.PersonId = IsNull(A.PersonId,0)  
  
 --Bank Details  
 Left Join CRM..TClientBankAccount F WITH(NOLOCK) On F.CRMContactId = A.CRMContactId And F.DefaultAccountFg = 1  
  
 Left Join CRM..TRefCounty H WITH(NOLOCK) On F.RefCountyId = H.RefCountyId  
 Left Join CRM..TRefCountry J WITH(NOLOCK) On F.RefCountryId = J.RefCountryId  
  
 --Adviser Reference  
 Inner Join CRM..TPractitioner K WITH(NOLOCK) On K.CRMContactId = @AdviserCRMId  
 Inner Join CRM..TCRMContact KName WITH(NOLOCK) On KName.CRMContactId = K.CRMContactId  
 Left Join CRM..TContact APhone WITH(NOLOCK) On APhone.CRMContactId = K.CRMContactId And APhone.RefContactType = 'Telephone' And APhone.DefaultFg = 1  
 Left Join CRM..TContact AMobile WITH(NOLOCK) On AMobile.CRMContactId = K.CRMContactId And AMobile.RefContactType = 'Mobile' And AMobile.DefaultFg = 1  
 Left Join CRM..TContact AEMail WITH(NOLOCK) On AEMail.CRMContactId = K.CRMContactId And AEMail.RefContactType = 'E-Mail' And AEMail.DefaultFg = 1  
 Left Join CRM..TContact AFax WITH(NOLOCK) On AFax.CRMContactId = K.CRMContactId And AFax.RefContactType = 'Fax' And AFax.DefaultFg = 1  
  
 --Employment  
 Left Join FactFind..TEmploymentDetail L WITH(NOLOCK) On L.CRMContactId = A.CRMContactId  
 Left Join CRM..TRefOccupation M WITH(NOLOCK) On L.RefOccupationId = M.RefOccupationId  
  
 --Professional Contact - Dr info  
 Left Join FactFind..TProfessionalContact N On N.CRMContactId = A.CRMContactId And N.ContactType = 'Doctor'  
  
 --Firm  
 Inner Join Administration..TIndigoClient TIC WITH(NOLOCK) On TIC.IndigoClientId = A.IndClientId  
 Left Join CRM..TRefCounty ICCounty WITH(NOLOCK) On TIC.County = ICCounty.RefCountyId  
 Left Join CRM..TRefCountry ICCountry WITH(NOLOCK) On TIC.Country = ICCountry.RefCountryId  
  
Where A.CRMContactId = @ClientCRMId1  
  
  
UNION ALL  
  
--Firm & Client & Bank & Employment & Professional Contact details for client1  
Select  
 2 As Tag,  
 1 As Parent,  
  
 Null, --Root  
  
 --Firm  
 TIC.IndigoClientId AS [Data!2!IndigoClientId],  
 TIC.Identifier AS [Data!2!Identifier],  
 Case When IsNull(TIC.FSA,'') <> '' Then IsNull(TIC.FSA,'') Else IsNull(TIC.SIB,'') End AS [Data!2!FirmId],  
 IsNull(TIC.AddressLine1,'') AS [Data!2!FirmAddressLine1],  
 IsNull(TIC.AddressLine2,'') AS [Data!2!FirmAddressLine2],  
 IsNull(TIC.AddressLine3,'') AS [Data!2!FirmAddressLine3],  
 IsNull(TIC.AddressLine4,'') AS [Data!2!FirmAddressLine4],  
 IsNull(TIC.CityTown,'') AS [Data!2!FirmCityTown],  
 IsNull(ICCounty.CountyName,'') AS [Data!2!FirmCountyName],  
 IsNull(ICCountry.CountryName,'') AS [Data!2!FirmCountryName],  
 IsNull(TIC.EmailAddress,'') AS [Data!2!FirmEmailAddress],  
 IsNull(TIC.Postcode,'') AS [Data!2!FirmPostCode],  
  
 --Adviser  
 IsNull(K.FSAReference,'') AS [Data!2!AdviserReference],  
 IsNull(KName.FirstName + ' ' + KName.LastName,'') AS [Data!2!AdviserName],  
 IsNull(APhone.Value,'') AS [Data!2!AdviserTelephone],  
 IsNull(AMobile.Value,'') AS [Data!2!AdviserMobile],  
 IsNull(AEMail.Value,'') AS [Data!2!AdviserEmail],  
 IsNull(AFax.Value,'') AS [Data!2!AdviserFax],  
  
 --Client  
 IsNull(A.CRMContactId,0) AS [Data!2!ClientCRMId],  
 IsNull(A.ExternalReference,'') AS [Data!2!ICRNe],  
 IsNull(C.AddressLine1,'') AS [Data!2!ClientAddressLine1],  
 IsNull(C.AddressLine2,'') AS [Data!2!ClientAddressLine2],  
 IsNull(C.AddressLine3,'') AS [Data!2!ClientAddressLine3],  
 IsNull(C.AddressLine4,'') AS [Data!2!ClientAddressLine4],  
 IsNull(C.CityTown,'') AS [Data!2!ClientCityTown],  
 IsNull(D.CountyName,'') AS [Data!2!ClientCountyName],  
 IsNull(E.CountryName,'') AS [Data!2!ClientCountryName],  
 IsNull(C.Postcode,'') AS [Data!2!ClientPostCode],  
 IsNull(B.AddressTypeName,'') AS [Data!2!ClientAddressType],  
 IsNull(CPhone.Value,'') AS [Data!2!ClientTelephone],  
 IsNull(CMobile.Value,'') AS [Data!2!ClientMobile],  
 IsNull(CEMail.Value,'') AS [Data!2!ClientEmail],  
 IsNull(CFax.Value,'') AS [Data!2!ClientFax],  
  
 IsNull(CPerson.NINumber,'') AS [Data!2!NINumber],  
 IsNull(CPerson.UKResident,0) AS [Data!2!UKResident],  
 IsNull(CPerson.ResidentIn,'') AS [Data!2!ResidentIn],  
 IsNull(CPerson.MaritalStatus,'') AS [Data!2!MaritalStatus],  
  
 --Bank  
 IsNull(F.BankName,'') AS [Data!2!BankName],  
 IsNull(F.AccountHolders,'') AS [Data!2!BankAccountHolders],  
 IsNull(F.AccountName,'') AS [Data!2!BankAccountName],  
 IsNull(F.AddressLine1,'') AS [Data!2!BankAddressLine1],  
 IsNull(F.AddressLine2,'') AS [Data!2!BankAddressLine2],  
 IsNull(F.AddressLine3,'') AS [Data!2!BankAddressLine3],  
 IsNull(F.AddressLine4,'') AS [Data!2!BankAddressLine4],  
 IsNull(F.CityTown,'') AS [Data!2!BankCityTown],  
 IsNull(H.CountyName,'') AS [Data!2!BankCountyName],  
 IsNull(J.CountryName,'') AS [Data!2!BankCountryName],  
 IsNull(F.Postcode,'') AS [Data!2!BankPostCode],  
 IsNull(F.AccountNumber,'') AS [Data!2!BankAccountNumber],  
 IsNull(F.SortCode,'') AS [Data!2!BankSortCode],  
  
 --Employment  
 IsNull(L.EmploymentStatus,'') AS [Data!2!EmploymentStatus],  
 IsNull(L.Employer,'') AS [Data!2!Employer],  
 IsNull(M.Description,'Unknown Occupation (assumed non-hazardous for quotation)') AS [Data!2!Occupation],  
 IsNull(M.OrigoCode,'') AS [Data!2!OccupationCode],  
  
 --Professional Contact - Dr info  
 IsNull(N.ContactName,'') AS [Data!2!DoctorsName],  
 IsNull(N.CompanyName,'') AS [Data!2!SurgeryName],  
 IsNull(N.AddressLine1,'') AS [Data!2!SurgeryAddressLine1],  
 IsNull(N.AddressLine2,'') AS [Data!2!SurgeryAddressLine2],  
 IsNull(N.AddressLine3,'') AS [Data!2!SurgeryAddressLine3],  
 IsNull(N.AddressLine4,'') AS [Data!2!SurgeryAddressLine4],  
 IsNull(N.CityTown,'') AS [Data!2!SurgeryCityTown],  
 IsNull(N.County,'') AS [Data!2!SurgeryCountyName],  
 IsNull(N.Postcode,'') AS [Data!2!SurgeryPostCode],  
 IsNull(N.TelephoneNumber,'') AS [Data!2!SurgeryPhoneNo]  
  
From CRM..TCRMContact A WITH(NOLOCK)  
 Left Join CRM..TAddress B WITH(NOLOCK) On A.CRMContactId = B.CRMContactId And B.DefaultFg = 1  
 Left Join CRM..TAddressStore C WITH(NOLOCK) On B.AddressStoreId = C.AddressStoreId  
   
 Left Join CRM..TRefCounty D WITH(NOLOCK) On C.RefCountyId = D.RefCountyId  
 Left Join CRM..TRefCountry E WITH(NOLOCK) On C.RefCountryId = E.RefCountryId  
  
 --Client Contacts  
 Left Join CRM..TContact CPhone WITH(NOLOCK) On CPhone.CRMContactId = A.CRMContactId And CPhone.RefContactType = 'Telephone' And CPhone.DefaultFg = 1  
 Left Join CRM..TContact CMobile WITH(NOLOCK) On CMobile.CRMContactId = A.CRMContactId And CMobile.RefContactType = 'Mobile' And CMobile.DefaultFg = 1  
 Left Join CRM..TContact CEMail WITH(NOLOCK) On CEMail.CRMContactId = A.CRMContactId And CEMail.RefContactType = 'E-Mail' And CEMail.DefaultFg = 1  
 Left Join CRM..TContact CFax WITH(NOLOCK) On CFax.CRMContactId = A.CRMContactId And CFax.RefContactType = 'Fax' And CFax.DefaultFg = 1  
  
 --Person Details  
 Left Join CRM..TPerson CPerson WITH(NOLOCK) On CPerson.PersonId = IsNull(A.PersonId,0)  
  
 --Bank Details  
 Left Join CRM..TClientBankAccount F WITH(NOLOCK) On F.CRMContactId = A.CRMContactId And F.DefaultAccountFg = 1  
  
 Left Join CRM..TRefCounty H WITH(NOLOCK) On F.RefCountyId = H.RefCountyId  
 Left Join CRM..TRefCountry J WITH(NOLOCK) On F.RefCountryId = J.RefCountryId  
  
 --Adviser Reference  
 Inner Join CRM..TPractitioner K WITH(NOLOCK) On K.CRMContactId = @AdviserCRMId  
 Inner Join CRM..TCRMContact KName WITH(NOLOCK) On KName.CRMContactId = K.CRMContactId  
 Left Join CRM..TContact APhone WITH(NOLOCK) On APhone.CRMContactId = K.CRMContactId And APhone.RefContactType = 'Telephone' And APhone.DefaultFg = 1  
 Left Join CRM..TContact AMobile WITH(NOLOCK) On AMobile.CRMContactId = K.CRMContactId And AMobile.RefContactType = 'Mobile' And AMobile.DefaultFg = 1  
 Left Join CRM..TContact AEMail WITH(NOLOCK) On AEMail.CRMContactId = K.CRMContactId And AEMail.RefContactType = 'E-Mail' And AEMail.DefaultFg = 1  
 Left Join CRM..TContact AFax WITH(NOLOCK) On AFax.CRMContactId = K.CRMContactId And AFax.RefContactType = 'Fax' And AFax.DefaultFg = 1  
  
 --Employment  
 Left Join FactFind..TEmploymentDetail L WITH(NOLOCK) On L.CRMContactId = A.CRMContactId  
 Left Join CRM..TRefOccupation M WITH(NOLOCK) On L.RefOccupationId = M.RefOccupationId  
  
 --Professional Contact - Dr info  
 Left Join FactFind..TProfessionalContact N On N.CRMContactId = A.CRMContactId And N.ContactType = 'Doctor'  
  
 --Firm  
 Inner Join Administration..TIndigoClient TIC WITH(NOLOCK) On TIC.IndigoClientId = A.IndClientId  
 Left Join CRM..TRefCounty ICCounty WITH(NOLOCK) On TIC.County = ICCounty.RefCountyId  
 Left Join CRM..TRefCountry ICCountry WITH(NOLOCK) On TIC.Country = ICCountry.RefCountryId  
  
Where A.CRMContactId = @ClientCRMId2  
  
  
For XML Explicit  

GO
