SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[SpCustomCreateClient]          
 @CRMContactTypeId int,        
 @CorporateName varchar(255)=NULL,       
 @RefTrustTypeId bigint = NULL,      
 @RefCorporateTypeId bigint = NULL,  
 @FirstName varchar(255)=NULL,         
 @LastName varchar(255)=NULL,       
 @MiddleName varchar(255)=NULL,           
 @Title varchar(50)=NULL,       
 @DOB datetime='01 Jan 1800',         
 @Gender varchar(50)=NULL,       
 @PractitionerId bigint,    
 @NINumber varchar(50)='',  
 @AddressLine1 varchar(255)='',         
 @AddressLine2  varchar(255)='',          
 @AddressLine3 varchar(255)='',       
 @AddressLine4 varchar(255)='',       
 @City varchar(255)='',       
 @CountyId bigint = 0,       
 @PostCode varchar(10)='',       
 @CountryId bigint = 0,           
 @RefAddressTypeId int,       
 @FromAddress datetime = '',  
 @RefAddressStatusId int = 1,  
 @TelephoneNumber varchar(255)=NULL,       
 @FaxNumber varchar(255)=NULL,       
 @Email varchar(255)=NULL,       
 @Mobile varchar(255)=NULL,       
 @Web varchar(255)=NULL,   
 @RefServiceStatusId bigint=null,       
 @Notes varchar(8000) = NULL,           
 @DPAMail bit = 1,      
 @DPATelephone bit = 1,      
 @DPAEmail bit = 1,      
 @DPASMS bit = 1,      
 @DPAOtherMail bit = 1,      
 @DPAOtherTelephone bit = 1,      
 @DPAOtherEmail bit = 1,      
 @DPAOtherSMS bit = 1,      
 @ExternalReference varchar(255)='',        
 @AdditionalReference varchar(255)='',        
 @IndigoClientId bigint,       
 @RelatedCRMContactId bigint = 0,      
 @RelationshipTypeId bigint = 0,       
 @CreditedGroupId bigint = 0,      
 @StampUser varchar(50)      
      
As          
          
Declare @ServicingAdviserCRMContactId bigint          
Declare @ServicingAdviserUserId bigint          
Declare @AdviserName varchar(255)      
      
Declare @PersonId bigint          
Declare @CorporateId bigint       
Declare @TrustId bigint         
Declare @ClientCRMContactId bigint          
      
declare @ContactId bigint      
declare @NoteId bigint      
declare @RelationshipId bigint      
declare @CRMContactDpaQuestionsId bigint      
declare @CRMContactExtId bigint      
Declare @AddressStoreId bigint       
declare @AddressId bigint         
declare @AddressTypeName varchar(255)      
      
Declare @RelationshipTypeId2 bigint          
      
          
set @ClientCRMContactId = null          
          
          
if @DOB='01 Jan 1800'          
Begin          
 Set @DOB=NULL          
End          
          
          
SELECT       
@ServicingAdviserCRMContactId = A.CRMContactId,       
@ServicingAdviserUserId = u.UserId,      
@AdviserName = c.FirstName + ' ' + c.LastName      
from CRM..TPractitioner A          
join CRM..TCRMContact c ON c.CRMContactId = a.CRMContactId      
join administration..tuser u ON u.CRMContactId = c.CRMContactId      
where a.PractitionerId = @PractitionerId      
          
declare @xml varchar(8000)      
          
-- create person          
begin        
          
 if (@CRMContactTypeId = 2)          
 Begin          
  set @FirstName=null          
  set @LastName=null          
  set @DOB=null          
      
      
  INSERT INTO TTrust (RefTrustTypeId, IndClientId, TrustName, EstDate, ArchiveFG, ConcurrencyId )         
  VALUES (@RefTrustTypeId, @IndigoClientId, @CorporateName, null, 0, 1)         
         
    SELECT @TrustId = SCOPE_IDENTITY()        
       
  INSERT INTO TTrustAudit (RefTrustTypeId, IndClientId, TrustName, EstDate, ArchiveFG, ConcurrencyId, TrustId, StampAction,  StampDateTime, StampUser)        
  SELECT T1.RefTrustTypeId, T1.IndClientId, T1.TrustName, T1.EstDate, T1.ArchiveFG, T1.ConcurrencyId, T1.TrustId, 'C', GetDate(),  @StampUser        
  FROM TTrust T1        
  WHERE T1.TrustId=@TrustId        
      
 End          
          
          
          
 if (@CRMContactTypeId = 3)          
 Begin          
  set @FirstName=null          
  set @LastName=null          
  set @DOB=null          
      
      
  INSERT INTO TCorporate (IndClientId, CorporateName,ArchiveFg,BusinessType,  RefCorporateTypeId,   CompanyRegNo,   EstIncorpDate,   YearEnd,   VatRegFg,   VatRegNo,   ConcurrencyId)    
  VALUES(  @IndigoClientId,   @CorporateName,   0,   null,  @RefCorporateTypeId,   null,   null,   null,   null,   null,  1)  
         
  SELECT @CorporateId = SCOPE_IDENTITY()        
       
  INSERT INTO TCorporateAudit (  IndClientId,   CorporateName,   ArchiveFg,   BusinessType,   RefCorporateTypeId,   CompanyRegNo,   EstIncorpDate,   YearEnd,   VatRegFg,   VatRegNo,   ConcurrencyId,   CorporateId,  StampAction,  StampDateTime,  StampUser

  
)  
  
    
        
  SELECT  IndClientId,   CorporateName,   ArchiveFg,   BusinessType,   RefCorporateTypeId,   CompanyRegNo,   EstIncorpDate,   YearEnd,   VatRegFg,   VatRegNo,   ConcurrencyId,  CorporateId,  'C',  GetDate(),  @StampUser        
  FROM TCorporate        
  WHERE CorporateId = @CorporateId        
      
 End          
          
 if (@CRMContactTypeId = 1)          
 Begin          
       
  set @CorporateName=null          
  set @CorporateId=null          
          
  INSERT INTO TPerson (Title, FirstName, MiddleName, LastName, DOB, GenderType, IndClientId, NINumber)      
  SELECT @Title, @FirstName, @MiddleName, @LastName, @DOB, @Gender, @IndigoClientId, @NINumber      
       
  SELECT @PersonId = SCOPE_IDENTITY()        
      
  INSERT INTO TPersonAudit (Title, FirstName, MiddleName, LastName, DOB, GenderType, IndClientId, NINumber, PersonId, StampAction, StampDateTime, StampUser)      
  SELECT @Title, @FirstName, @MiddleName, @LastName, @DOB, @Gender, @IndigoClientId, @NINumber, @PersonId, 'C', getdate(), @StampUser      
       
      
 End          
           
        
 -- create crm contact / we have taken ownership       
      
 IF Exists(SELECT * FROM Administration..TFormatValidation WHERE IndigoClientId = @IndigoClientId AND Entity = 'ExternalReference') AND @ExternalReference = ''        
 SET @ExternalReference = 'To be defined'        
         
 INSERT INTO TCRMContact (RefCRMContactStatusId, PersonId, CorporateId, TrustId, AdvisorRef, Notes, ArchiveFg,   LastName,   FirstName,   CorporateName,   DOB,   Postcode,   OriginalAdviserCRMId,   CurrentAdviserCRMId,   CurrentAdviserName,   CRMContactType,   IndClientId,   FactFindId,   InternalContactFG,   RefServiceStatusId,   MigrationRef,   ExternalReference,  CampaignDataId,  AdditionalRef,  _ParentId,   _ParentTable,   _ParentDb,   _OwnerId,   ConcurrencyId )         
 VALUES (1, @PersonId, @CorporateId, @TrustId, default, default, 0, @LastName, @FirstName, @CorporateName, @DOB, @Postcode, @ServicingAdviserCRMContactId, @ServicingAdviserCRMContactId, @AdviserName, @CRMContactTypeId, @IndigoClientId, default, default, @RefServiceStatusId, default, @ExternalReference, default, @AdditionalReference, null, null, null, @ServicingAdviserUserId, 1)           
       
 SELECT @ClientCRMContactId = SCOPE_IDENTITY()        
      
 IF @ExternalReference = ''        
 BEGIN        
  UPDATE TCRMContact         
  SET ExternalReference = convert(varchar(10),CurrentAdviserCRMId) + '-' + replicate(0, (8-len(CRMContactId))) + convert(varchar(10),CRMContactId)        
  WHERE CRMContactId = @ClientCRMContactId        
 END        
      
 INSERT INTO TCRMContactAudit (RefCRMContactStatusId, PersonId, CorporateId, TrustId, AdvisorRef, Notes, ArchiveFg,   LastName,   FirstName,   CorporateName,   DOB,   Postcode,   OriginalAdviserCRMId,   CurrentAdviserCRMId,   CurrentAdviserName,     
 CRMContactType,   IndClientId,   FactFindId,   InternalContactFG,   RefServiceStatusId,   MigrationRef,   ExternalReference,  CampaignDataId,  AdditionalRef,  _ParentId,   _ParentTable,   _ParentDb,   _OwnerId,   ConcurrencyId, CRMContactId, StampAction,

 StampDateTime, StampUser )         
 SELECT RefCRMContactStatusId, PersonId, CorporateId, TrustId, AdvisorRef, Notes, ArchiveFg,   LastName,   FirstName,  CorporateName,   DOB,   Postcode,   OriginalAdviserCRMId,   CurrentAdviserCRMId,   CurrentAdviserName,   CRMContactType,   IndClientId,


  
  FactFindId,   InternalContactFG,   RefServiceStatusId,   MigrationRef,   ExternalReference,  CampaignDataId,  AdditionalRef,  _ParentId,   _ParentTable,   _ParentDb,   _OwnerId,   ConcurrencyId, CRMContactId, 'C', getdate(), @StampUser       
 FROM CRM..TCRMContact       
 WHERE CRMContactId = @ClientCRMContactId       
      
       
           
           
         
 If Len(Rtrim(Ltrim(@AddressLine1))) > 0          
 Begin          
              
  INSERT INTO TAddressStore (  IndClientId,   AddressLine1,   AddressLine2,   AddressLine3,   AddressLine4,   CityTown,   RefCountyId,   Postcode,   RefCountryId,   PostCodeX,   PostCodeY,   ConcurrencyId )         
  VALUES (  @IndigoClientId,   @AddressLine1,   @AddressLine2,   @AddressLine3,   @AddressLine4,   @City,   @CountyId,   @Postcode,   @CountryId,   default,   default,   1)         
      
  SELECT @AddressStoreId = SCOPE_IDENTITY()        
      
  INSERT INTO TAddressStoreAudit (  IndClientId,   AddressLine1,   AddressLine2,   AddressLine3,   AddressLine4,   CityTown,   RefCountyId,   Postcode,   RefCountryId,   PostCodeX,   PostCodeY,   ConcurrencyId,  AddressStoreId,  StampAction,  StampDateTime,  StampUser)        
  SELECT  T1.IndClientId,   T1.AddressLine1,   T1.AddressLine2,   T1.AddressLine3,   T1.AddressLine4,   T1.CityTown,   T1.RefCountyId,   T1.Postcode,   T1.RefCountryId,   T1.PostCodeX,   T1.PostCodeY,   T1.ConcurrencyId,  T1.AddressStoreId,  'C',  GetDate(),  @StampUser        
  FROM TAddressStore T1        
  WHERE T1.AddressStoreId=@AddressStoreId      
      
     if @RefAddressTypeId = 1      
   set @AddressTypeName = 'Home'      
  if @RefAddressTypeId = 2      
   set @AddressTypeName = 'Business'      
  if @RefAddressTypeId = 3      
   set @AddressTypeName = 'Other'      
  if @RefAddressTypeId = 4      
   set @AddressTypeName = 'Registered'      
      
        
  INSERT INTO TAddress (IndClientId,   CRMContactId,   AddressStoreId,   RefAddressTypeId,   AddressTypeName,   DefaultFg, RefAddressStatusId, ResidentFromDate, ConcurrencyId )         
  VALUES (  @IndigoClientId,   @ClientCRMContactId,   @AddressStoreId,   @RefAddressTypeId,   @AddressTypeName,   1, @RefAddressStatusId, @FromAddress, 1)  
      
  SELECT @AddressId = SCOPE_IDENTITY()        
      
  INSERT INTO TAddressAudit (  IndClientId,   CRMContactId,   AddressStoreId,   RefAddressTypeId,   AddressTypeName,   DefaultFg,RefAddressStatusId, ResidentFromDate,   ConcurrencyId,  AddressId,  StampAction,  StampDateTime,  StampUser)        
  SELECT  T1.IndClientId,   T1.CRMContactId,   T1.AddressStoreId,   T1.RefAddressTypeId,   T1.AddressTypeName,   T1.DefaultFg, T1.RefAddressStatusId, T1.ResidentFromDate,  T1.ConcurrencyId,  T1.AddressId,  'C',  GetDate(),  @StampUser        
  FROM TAddress T1        
  WHERE T1.AddressId=@AddressId        
      
       
      
 End          
          
      
      
 -- contact values          
 IF @TelephoneNumber <> ''        
 BEGIN      
  INSERT INTO TContact ( IndClientId,   CRMContactId,   RefContactType,   Description,   Value,   DefaultFg,   ConcurrencyId )         
  VALUES (@IndigoClientId, @ClientCRMContactId, 'Telephone', 'Telephone', @TelephoneNumber, 1, 1)         
        
  SELECT @ContactId = SCOPE_IDENTITY()        
        
  INSERT INTO TContactAudit (  IndClientId,   CRMContactId,   RefContactType,   Description,   Value,   DefaultFg,   ConcurrencyId,  ContactId,   StampAction,   StampDateTime,   StampUser)        
  SELECT T1.IndClientId,   T1.CRMContactId,   T1.RefContactType,   T1.Description,   T1.Value,   T1.DefaultFg,   T1.ConcurrencyId,  T1.ContactId,  'C',   GetDate(),  @StampUser        
  FROM TContact T1        
  WHERE T1.ContactId=@ContactId        
 END      
      
 IF @FaxNumber <> ''        
 BEGIN      
  INSERT INTO TContact ( IndClientId,   CRMContactId,   RefContactType,   Description,   Value,   DefaultFg,   ConcurrencyId )         
  VALUES (@IndigoClientId, @ClientCRMContactId, 'Fax', 'Fax', @FaxNumber, 1, 1)         
        
  SELECT @ContactId = SCOPE_IDENTITY()        
        
  INSERT INTO TContactAudit (  IndClientId,   CRMContactId,   RefContactType,   Description,   Value,   DefaultFg,   ConcurrencyId,  ContactId,   StampAction,   StampDateTime,   StampUser)        
  SELECT T1.IndClientId,   T1.CRMContactId,   T1.RefContactType,   T1.Description,   T1.Value,   T1.DefaultFg,   T1.ConcurrencyId,  T1.ContactId,  'C',   GetDate(),  @StampUser        
  FROM TContact T1        
  WHERE T1.ContactId=@ContactId        
 END      
      
 IF @Email <> ''        
 BEGIN      
  INSERT INTO TContact ( IndClientId,   CRMContactId,   RefContactType,   Description,   Value,   DefaultFg,   ConcurrencyId )         
  VALUES (@IndigoClientId, @ClientCRMContactId, 'E-Mail', 'E-Mail', @Email, 1, 1)         
        
  SELECT @ContactId = SCOPE_IDENTITY()        
        
  INSERT INTO TContactAudit (  IndClientId,   CRMContactId,   RefContactType,   Description,   Value,   DefaultFg,   ConcurrencyId,  ContactId,   StampAction,   StampDateTime,   StampUser)        
  SELECT T1.IndClientId,   T1.CRMContactId,   T1.RefContactType,   T1.Description,   T1.Value,   T1.DefaultFg,   T1.ConcurrencyId,  T1.ContactId,  'C',   GetDate(),  @StampUser        
  FROM TContact T1        
  WHERE T1.ContactId=@ContactId        
 END      
      
 IF @Mobile <> ''        
 BEGIN      
  INSERT INTO TContact ( IndClientId,   CRMContactId,   RefContactType,   Description,   Value,   DefaultFg,   ConcurrencyId )         
  VALUES (@IndigoClientId, @ClientCRMContactId, 'Mobile', 'Mobile', @Mobile, 1, 1)         
        
  SELECT @ContactId = SCOPE_IDENTITY()        
        
  INSERT INTO TContactAudit (  IndClientId,   CRMContactId,   RefContactType,   Description,   Value,   DefaultFg,   ConcurrencyId,  ContactId,   StampAction,   StampDateTime,   StampUser)        
  SELECT T1.IndClientId,   T1.CRMContactId,   T1.RefContactType,   T1.Description,   T1.Value,   T1.DefaultFg,   T1.ConcurrencyId,  T1.ContactId,  'C',   GetDate(),  @StampUser        
  FROM TContact T1        
  WHERE T1.ContactId=@ContactId        
 END      
      
 IF @Web <> ''        
 BEGIN      
  INSERT INTO TContact ( IndClientId,   CRMContactId,   RefContactType,   Description,   Value,   DefaultFg,   ConcurrencyId )         
  VALUES (@IndigoClientId, @ClientCRMContactId, 'Web Site', 'Web Site', @Web, 1, 1)         
        
  SELECT @ContactId = SCOPE_IDENTITY()        
        
  INSERT INTO TContactAudit (  IndClientId,   CRMContactId,   RefContactType,   Description,   Value,   DefaultFg,   ConcurrencyId,  ContactId,   StampAction,   StampDateTime,   StampUser)        
  SELECT T1.IndClientId,   T1.CRMContactId,   T1.RefContactType,   T1.Description,   T1.Value,   T1.DefaultFg,   T1.ConcurrencyId,  T1.ContactId,  'C',   GetDate(),  @StampUser        
  FROM TContact T1        
  WHERE T1.ContactId=@ContactId        
 END      
      
           
           
 -- lets capture notes          
 if (isnull(@Notes,'') <> '')        
 begin      
  declare @Prefix varchar(255)    
  set @Prefix = (select isnull(firstname + ' ' + lastname ,'')    
  from CRM..TCRMContact c    
  join administration..tuser u on u.CRMContactId = c.CRMContactId    
  where u.userid = @StampUser)    
    
  set @prefix = @prefix + ' ' + convert(varchar(50),getdate(),103) + ' ' + substring(convert(varchar(50),getdate(),108),1,6)    
--  set @Notes = @prefix + ' ' + @Notes    
     
--quick hack to fix the pound sign issue   
 select @Notes = replace(@Notes,'£','')  
  
  INSERT INTO TNote (  EntityType,   EntityId,   Notes,   LatestNote,   ConcurrencyId )         
  VALUES (  'crmcontact',   @ClientCRMContactId,  @prefix + ' ' +  @Notes,   @prefix + ' ' +  @Notes, 1)         
      
  SELECT @NoteId = SCOPE_IDENTITY()        
      
  INSERT INTO TNoteAudit (  EntityType,   EntityId,   Notes,   LatestNote,   ConcurrencyId,  NoteId,  StampAction,  StampDateTime,  StampUser)        
  SELECT  T1.EntityType,   T1.EntityId,   T1.Notes,   T1.LatestNote,   T1.ConcurrencyId,  T1.NoteId,  'C',  GetDate(),  @StampUser        
  FROM TNote T1        
  WHERE T1.NoteId=@NoteId        
   end      
       
           
      
  -- lets deal with the relationships          
       
 if @RelatedCRMContactId > 0      
 begin        
  select @RelationshipTypeId2=RefRelCorrespondTypeId from crm..trefrelationshiptypelink where RefRelTypeId=@RelationshipTypeId          
      
  INSERT INTO TRelationship (RefRelTypeId,   RefRelCorrespondTypeId,   CRMContactFromId,   CRMContactToId, ConcurrencyId )         
  VALUES (  @RelationshipTypeId,   @RelationshipTypeId2,   @ClientCRMContactId,   @RelatedCRMContactId, 1)         
      
  SELECT @RelationshipId = SCOPE_IDENTITY()        
      
  INSERT INTO TRelationshipAudit (RefRelTypeId,   RefRelCorrespondTypeId,   CRMContactFromId,   CRMContactToId,   ExternalContact,   ExternalURL,   OtherRelationship,   ConcurrencyId,  RelationshipId,  StampAction,  StampDateTime,  StampUser)        
  SELECT  T1.RefRelTypeId,   T1.RefRelCorrespondTypeId,   T1.CRMContactFromId,   T1.CRMContactToId,   T1.ExternalContact,   T1.ExternalURL,   T1.OtherRelationship,   T1.ConcurrencyId,  T1.RelationshipId,  'C',  GetDate(),  @StampUser        
  FROM TRelationship T1        
  WHERE T1.RelationshipId=@RelationshipId        
       
      
      INSERT INTO TRelationship (RefRelTypeId,   RefRelCorrespondTypeId,   CRMContactFromId,   CRMContactToId, ConcurrencyId )         
  VALUES (  @RelationshipTypeId2,   @RelationshipTypeId,  @RelatedCRMContactId,  @ClientCRMContactId, 1)         
      
  SELECT @RelationshipId = SCOPE_IDENTITY()        
      
  INSERT INTO TRelationshipAudit (RefRelTypeId,   RefRelCorrespondTypeId,   CRMContactFromId,   CRMContactToId,   ExternalContact,   ExternalURL,   OtherRelationship,   ConcurrencyId,  RelationshipId,  StampAction,  StampDateTime,  StampUser)        
  SELECT  T1.RefRelTypeId,   T1.RefRelCorrespondTypeId,   T1.CRMContactFromId,   T1.CRMContactToId,   T1.ExternalContact,   T1.ExternalURL,   T1.OtherRelationship,   T1.ConcurrencyId,  T1.RelationshipId,  'C',  GetDate(),  @StampUser        
  FROM TRelationship T1        
  WHERE T1.RelationshipId=@RelationshipId        
      
 end           
          
      
  -- lets deal with the DPA Questions          
      
 INSERT INTO TCRMContactDpaQuestions (  CRMContactId,   Mail,   Telephone,   Email,   Sms,   OtherMail,   OtherTelephone,   OtherEmail,   OtherSms,   ConcurrencyId)        
 VALUES(  @ClientCRMContactId,   @DPAMail,   @DPATelephone,   @DPAEmail,   @DPASms,   @DPAOtherMail,   @DPAOtherTelephone,   @DPAOtherEmail,   @DPAOtherSms,  1)        
      
 SELECT @CRMContactDpaQuestionsId = SCOPE_IDENTITY()        
      
 INSERT INTO TCRMContactDpaQuestionsAudit (  CRMContactId,   Mail,   Telephone,   Email,   Sms,   OtherMail,   OtherTelephone,   OtherEmail,   OtherSms,   ConcurrencyId,  CRMContactDpaQuestionsId,  StampAction,  StampDateTime,  StampUser)        
 SELECT    CRMContactId,   Mail,   Telephone,   Email,   Sms,   OtherMail,   OtherTelephone,   OtherEmail,   OtherSms,   ConcurrencyId,  CRMContactDpaQuestionsId,  'C',  GetDate(),  @StampUser        
 FROM TCRMContactDpaQuestions        
 WHERE CRMContactDpaQuestionsId = @CRMContactDpaQuestionsId        
        
       
     -- Credited Group      
 INSERT INTO TCRMContactExt (  CRMContactId,   CreditedGroupId,   ConcurrencyId )         
 VALUES (  @ClientCRMContactId,   @CreditedGroupId,   1)         
       
 SELECT @CRMContactExtId = SCOPE_IDENTITY()        
       
 INSERT INTO TCRMContactExtAudit (  CRMContactId,   CreditedGroupId,   ConcurrencyId,  CRMContactExtId,  StampAction,  StampDateTime,  StampUser)        
 SELECT  T1.CRMContactId,   T1.CreditedGroupId,   T1.ConcurrencyId,  T1.CRMContactExtId,  'C',  GetDate(),  @StampUser        
 FROM TCRMContactExt T1        
 WHERE T1.CRMContactExtId = @CRMContactExtId        
      
          
 exec crm..SpRetrieveCRMContactById @ClientCRMContactId      
       
      
end      
      
        
      
  
  
  

GO
