SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  procedure [dbo].[spCustomCreateGroupForNewTenant]

(
	@NewTenantId BIGINT
	,@SourceTenantId BIGINT
)
AS

BEGIN

DECLARE @GroupingId BIGINT
DECLARE @CorporateId BIGINT   
DECLARE @GroupCRMContactId BIGINT
declare @TopGroupingName varchar(64),
	@TopCorporateName varchar(64),
	@TopGroupName varchar(64)

select top 1 @TopGroupingName=Identifier FROM Administration..TGrouping 
WHERE IndigoClientId=@SourceTenantId and ParentId is null
order by GroupingId desc -- From live data, the most recent is the one in use

set @TopGroupingName=isnull(@TopGroupingName,'Organisation')

-- Default create the Organisation Group first and foremost.
SELECT top 1 @GroupingId = GroupingId FROM Administration..TGrouping --WHERE Identifier LIKE 'Organisation' AND IndigoClientId=@NewTenantId
WHERE IndigoClientId=@NewTenantId and ParentId is null

update Administration..TGrouping
set Identifier = @TopGroupingName
WHERE IndigoClientId=@NewTenantId and GroupingId = @GroupingId

select top 1 @TopCorporateName = CorporateName
from CRM..TCorporate where IndClientId=@SourceTenantId
order by CorporateId

EXEC CRM..spCreateCorporate @StampUser='0',@IndClientId=@NewTenantId, @CorporateName=@TopCorporateName,@ArchiveFg=0,@BusinessType=NULL,@RefCorporateTypeId=NULL,    
 @CompanyRegNo=NULL,@EstIncorpDate=NULL,@YearEnd=NULL,@VatRegFg=NULL,@VatRegNo=NULL    
    
SELECT @CorporateId=CorporateId from CRM..TCorporate where IndClientId=@NewTenantId

EXEC CRM..spCreateCRMContact @StampUser='0',@RefCRMContactStatusId=1,@PersonId=default,    
 @CorporateId=@CorporateId,@TrustId=default,@AdvisorRef=default,@Notes=default,@ArchiveFg=0,@LastName=default,    
 @FirstName=default,@CorporateName=@TopCorporateName,@DOB=default,@Postcode=default,@OriginalAdviserCRMId=default,    
 @CurrentAdviserCRMId=default,@CurrentAdviserName=default,@CRMContactType=3,@IndClientId=@NewTenantId,    
 @FactFindId=default,@InternalContactFG=1, @RefServiceStatusId=default, @MigrationRef=default, @CreatedDate=default,    
 @ExternalReference=default,@CampaignDataId=default,@AdditionalRef=default,@_ParentId=default,@_ParentTable=default,    
 @_ParentDb=default,@_OwnerId=default    
    
SELECT @GroupCRMContactId = CRMcontactId from CRM..TCRMContact where CorporateId=@CorporateId    

select top 1 @TopGroupName = Identifier
from Administration..TGroup
where IndigoClientId = @SourceTenantId
and ParentId is null
order by GroupId desc

EXEC administration..spCreateGroup @StampUser='0', @Identifier=@TopGroupName, @GroupingId=@GroupingId,    
 @ParentId=NULL, @CRMContactId=@GroupCRMContactId, @IndigoClientId=@NewTenantId, @LegalEntity=1,    
 @GroupImageLocation=NULL, @AcknowledgementsLocation=NULL, @FinancialYearEnd=NULL, @ApplyFactFindBranding=default,    
 @VatRegNbr=NULL,@AuthorisationText=NULL    

-- Now Create the rest of the groups in the hierarchy.
Declare @SourceGroupingId bigint, @SourceGroupId bigint, @NewGroupId bigint, @GroupingIdentifier varchar(255), @NewGroupingID bigint        

       
 DECLARE group_cursor CURSOR        
    FOR		
		SELECT GroupId, GroupingId FROM Administration..TGroup A where indigoclientid=@SourceTenantId  AND   Identifier != @TopGroupName --NOT LIKE 'Organisation'    
 OPEN group_cursor        
        
 FETCH NEXT FROM group_cursor Into @SourceGroupId, @SourceGroupingId         
        
 WHILE @@FETCH_STATUS = 0        
    BEGIN        
          
	  --lets create the corporate        
	  Insert into CRM..TCorporate (IndClientId, CorporateName, ConcurrencyId)        
	  select @NewTenantId, A.CorporateName, 1 from CRM..TCorporate A        
	  inner join CRM..TCRMContact b on a.corporateid=b.corporateId        
	  inner join administration..tgroup c on c.crmcontactid=b.crmcontactid        
	  where c.groupid=@SourceGroupId        

	  Set @CorporateId=SCOPE_IDENTITY()        
	  
	  -- Insert onto Corporate Audit.	        
	  Insert into CRM..TCorporateAudit (IndClientId, CorporateName, ConcurrencyId, CorporateId,StampAction,StampDateTime, StampUser)         
	  Select IndClientId, CorporateName, ConcurrencyId, CorporateId, 'C', GETDATE(), '999999'
	  FROM  CRM..TCorporate Where CorporateId = @CorporateId
	  

	  -- Insert Into TCRMContact        
	  Insert into CRM..TCRMContact (RefCRMContactStatusId, CorporateId, ArchiveFG, CorporateName,         
	  originaladviserCRMID, CurrentAdviserCRMId, CRMContactType, IndClientId, InternalContactFG, CreatedDate, externalreference, concurrencyid)        
	  select 1,@CorporateId,0, A.CorporateName,         
	  0,0,3,@NewTenantId, 1,getDate(),null,1  from CRM..TCorporate A        
	  inner join CRM..TCRMContact b on a.corporateid=b.corporateId        
	  inner join administration..tgroup c on c.crmcontactid=b.crmcontactid        
	  where c.groupid=@SourceGroupId        
	        
	  Set @GRoupCRMContactId =SCOPE_IDENTITY()      
	  
	  -- Insert Into TCRMContactAudit
	  Insert into CRM..TCRMContactAudit (RefCRMContactStatusId, CorporateId, ArchiveFG, CorporateName, originaladviserCRMID, CurrentAdviserCRMId, CRMContactType,       
	  IndClientId, InternalContactFG, CreatedDate, externalreference, concurrencyid, crmcontactid,StampAction,StampDateTime, StampUser)
	  SELECT RefCRMContactStatusId, CorporateId, ArchiveFG, CorporateName, originaladviserCRMID, CurrentAdviserCRMId, CRMContactType,       
	  IndClientId, InternalContactFG, CreatedDate, externalreference, concurrencyid, crmcontactid  , 'C', GETDATE(), '999999'
	  FROM CRM..TCRMContact WHERE CRMContactId = @GRoupCRMContactId
	  
	  -- Insert Into TGroup
	  Insert into administration..TGroup (        
		Identifier,GroupingId,ParentId,CRMContactId,IndigoClientId,LegalEntity,GroupImageLocation,AcknowledgementsLocation,        
		FinancialYearEnd,ApplyFactFindBranding,VatRegNbr,AuthorisationText,ConcurrencyId)        
	  Select Identifier,GroupingId,null,@GRoupCRMContactId,@NewTenantId,LegalEntity,GroupImageLocation,AcknowledgementsLocation,        
		FinancialYearEnd,ApplyFactFindBranding,VatRegNbr,AuthorisationText,ConcurrencyId         
	  from administration..tgroup where groupid=@SourceGroupId        
	        
	  Set @NewGroupId=SCOPE_IDENTITY()        
	  
	  -- Insert Into TGroupAudit
	  Insert into administration..TGroupAudit (        
		Identifier,GroupingId,ParentId,CRMContactId,IndigoClientId,LegalEntity,GroupImageLocation,AcknowledgementsLocation,        
		FinancialYearEnd,ApplyFactFindBranding,VatRegNbr,AuthorisationText,ConcurrencyId, GroupId,StampAction,StampDateTime, StampUser)
	  Select Identifier,GroupingId,ParentId,CRMContactId,IndigoClientId,LegalEntity,GroupImageLocation,AcknowledgementsLocation,        
		FinancialYearEnd,ApplyFactFindBranding,VatRegNbr,AuthorisationText,ConcurrencyId, GroupId, 'C', GETDATE(), '999999'
	  FROM 	TGroup Where GroupId = @NewGroupId
		        
	        
	  -- we need to know who the grouping is for the group added so we can update the groupingid        
	  select @GroupingIdentifier =Identifier from administration..tgrouping where groupingid=@SourceGroupingId        
	  select @NewGroupingID=GRoupingId from administration..TGrouping where identifier=@GroupingIdentifier  and IndigoClientId=@NEwTenantId        
	        
	  Update administration..TGroup set GRoupingid=@NewGroupingId where GRoupId=@NewGroupId        
	        
	  FETCH NEXT FROM group_cursor Into @SourceGroupId, @SourceGroupingId         
         
    END        
         
 CLOSE group_cursor         
    DEALLOCATE group_cursor        
        
-- for each group set the hierarchy        
        
if exists(select * from administration..TGroup where indigoclientid=@NewTenantId and ISNULL(parentid,0)=0)
begin

	update a 
	set a.ParentId = t.TargetParentId
	from Administration.dbo.TGroup a
		inner join Administration.dbo.TGroup b on b.Identifier = a.Identifier and b.IndigoClientId = @SourceTenantId
		outer apply (Select pa.GroupId as TargetParentId
			from Administration.dbo.TGroup pb
				inner join Administration.dbo.TGroup pa on  pa.Identifier = pb.Identifier and pa.IndigoClientId = @NewTenantId
			where pb.GroupId = b.ParentId and pb.IndigoClientId = @SourceTenantId) t
	where a.IndigoClientId = @NewTenantId

	---- some variable helpers
	--DECLARE @NewTenantGroupId bigint, @NewTenantParentGroupId bigint, @SourceParentGroupId bigint

	---- lets copy the hierarchy
	--DECLARE group_cursor CURSOR
	--FOR SELECT GroupId, ParentId FROM Administration..TGroup A
	--where indigoclientid=@SourceTenantId and ISNULL(parentid,0)>0 order by GroupId asc
	--OPEN group_cursor

	--FETCH NEXT FROM group_cursor Into @SourceGroupId ,@SourceParentGroupId

	--WHILE @@FETCH_STATUS = 0
	--	BEGIN
	--	-- we know this group has a parent
	--	SELECT @NewTenantGroupId=GroupId FROM Administration..TGroup where identifier in (Select Identifier from administration..TGroup where groupid=@SourceGroupId) and IndigoClientId=@NewTenantId
	--	SELECT @NewTenantParentGroupId=GroupId FROM Administration..TGroup where identifier in (Select Identifier from administration..TGRoup where groupid=@SourceParentGroupId) and IndigoClientId=@NEwTenantId

	--	Update Administration..TGroup Set ParentId=@NewTenantParentGroupId where GroupId=@NewTenantGroupId

	--	FETCH NEXT FROM group_cursor Into @SourceGroupId ,@SourceParentGroupId
	--END


	--CLOSE group_cursor
	--DEALLOCATE group_cursor
end
     



END





GO
