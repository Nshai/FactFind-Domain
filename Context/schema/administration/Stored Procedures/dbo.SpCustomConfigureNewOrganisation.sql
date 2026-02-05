SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
             
CREATE PROCEDURE [dbo].[SpCustomConfigureNewOrganisation]                
@IndigoClientId bigint,                
@SourceIndigoClientId bigint                
                
as          

PRINT 'In SpCustomConfigureNewOrganisation...'

SELECT '@IndigoClientId: ' + CONVERT(VARCHAR(20),@IndigoClientId)
SELECT '@SourceIndigoClientId: ' + CONVERT(VARCHAR(20),@SourceIndigoClientId)
                
              
                
declare @GroupingId bigint  
-- Declaring var's
--1. @ComplianceGradeRoleId
--2. @ComplianceGradeRoleIdentifier
-- for Compliance Grade Role (new column in TComplianceSetup)              
declare @AdviserRoleId bigint, @TnCCoachRoleId bigint, @FileCheckRoleId bigint , @ComplianceGradeRoleId bigint               
declare @SourceAdviserRoleId bigint, @SourceTnCCoachRoleId bigint, @SourceFileCheckRoleId bigint, @SourceComplianceGradeRoleId  bigint                
declare @MaxId bigint                
                
--0. Add a default Currency          
INSERT INTO TCurrencyRate (indigoclientid, currencycode, rate, date, concurrencyid)          
select  @IndigoClientId, 'GBP', 1.0, '20 dec 2007', 1          
          
                
--1. get the Organisation grouping                
 SELECT @GroupingId = GroupingId FROM TGrouping  WITH (NOLOCK) WHERE IndigoClientId = @IndigoClientId                
                
                
--2. Copy roles from source organisation                
 set @MaxId = (select max(roleId) from tRole)                
 INSERT INTO TRole (Identifier, RefLicenseTypeId,GroupingId, SuperUser, IndigoClientId, LicensedUserCount, Dashboard, ShowGroupDashboard, ConcurrencyId)                
 SELECT Identifier, RefLicenseTypeId,@GroupingId, SuperUser, @IndigoClientId, LicensedUserCount, Dashboard, ShowGroupDashboard, 1                
 FROM TRole WITH (NOLOCK)                
 WHERE IndigoClientId = @SourceIndigoClientId                
 AND Identifier NOT IN                 
  (                
  SELECT Identifier FROM TRole WITH (NOLOCK) WHERE IndigoClientId = @IndigoClientId                
  )                
                 
 INSERT INTO TRoleAudit (Identifier, GroupingId, SuperUser, IndigoClientId, LicensedUserCount, Dashboard, ShowGroupDashboard, ConcurrencyId, RoleId, HasGroupDataAccess, StampAction, StampDateTime, StampUser)                
 SELECT Identifier, GroupingId, SuperUser, @IndigoClientId, LicensedUserCount, Dashboard, ShowGroupDashboard, ConcurrencyId, RoleId, HasGroupDataAccess, 'C', getdate(), 0                
 FROM TRole WITH (NOLOCK)                
 WHERE IndigoClientId = @IndigoClientId                
 AND RoleId > @MaxId                

PRINT 'Roles for new Tenant:'                
SELECT Identifier FROM administration..TRole WHERE IndigoClientId = @IndigoClientId                
                
--3. Copy functional security keys - remove any existing keys first
DELETE FROM k
OUTPUT
    deleted.RightMask,
    deleted.SystemId,
    deleted.UserId,
    deleted.RoleId,
    deleted.ConcurrencyId,
    deleted.KeyId,
    'D',
    GETUTCDATE(),
    0
INTO
    administration.dbo.TKeyAudit (
    RightMask,
    SystemId,
    UserId,
    RoleId,
    ConcurrencyId,
    KeyId,
    StampAction,
    StampDateTime,
    StampUser)
FROM TKey k
JOIN TRole r ON r.RoleId = k.RoleId
WHERE r.IndigoClientId = @IndigoClientId

INSERT INTO TKey(RightMask, SystemId, UserId, RoleId, ConcurrencyId)
OUTPUT
    inserted.RightMask,
    inserted.SystemId,
    inserted.UserId,
    inserted.RoleId,
    inserted.ConcurrencyId,
    inserted.KeyId,
    'C',
    GETUTCDATE(),
    0
INTO
    administration.dbo.TKeyAudit (
    RightMask,
    SystemId,
    UserId,
    RoleId,
    ConcurrencyId,
    KeyId,
    StampAction,
    StampDateTime,
    StampUser)
SELECT k.RightMask, k.SystemId, null, new.RoleId, 1
FROM TKey k WITH (NOLOCK)
JOIN TRole source  WITH (NOLOCK) ON source.RoleId = k.RoleId AND k.UserId IS NULL AND source.IndigoClientId = @SourceIndigoClientId
JOIN TRole new  WITH (NOLOCK) ON new.Identifier = source.Identifier AND new.IndigoClientId = @IndigoClientId


--3.5 Entity keys   
 insert into administration..tpolicy (EntityId, RightMask, AdvancedMask, RoleId, Propogate, applied, IndigoclientId, ConcurrencyId)  
 select a.EntityId, a.RightMask, a.AdvancedMask, toRole.RoleId, 0, 'yes', toRole.IndigoclientId, 1   
 from TPolicy a  
 JOIN administration..trole fromRole on fromRole.RoleId = a.RoleId and fromRole.IndigoClientID = @SourceIndigoClientId  
 inner join administration..trole toRole on toRole.identifier=fromRole.identifier and toRole.IndigoClientId = @IndigoClientId  
 left join administration..tpolicy d on d.roleid=toRole.roleid  
 where d.roleid is null  
                 
                
--4. Copy report security keys - remove any existing keys first                
 DELETE FROM k                
 FROM Reporter..TReportKey k                
 JOIN TRole r ON r.RoleId = k.RoleId                
 WHERE r.IndigoClientId = @IndigoClientId                
                
 INSERT INTO Reporter..TReportKey(RightMask, AdvancedMask, EntityId, UserId, RoleId, ConcurrencyId, IsCategory)                
 SELECT k.RightMask, k.AdvancedMask, k.EntityId, null, new.RoleId, 1, k.IsCategory                
 FROM Reporter..TReportKey k WITH (NOLOCK)                
 JOIN TRole source  WITH (NOLOCK) ON source.RoleId = k.RoleId AND k.UserId IS NULL AND source.IndigoClientId = @SourceIndigoClientId                
 JOIN TRole new  WITH (NOLOCK) ON new.Identifier = source.Identifier AND new.IndigoClientId = @IndigoClientId                
                
                
                
                
--5. Get the Adviser and TnCCoach roles and update TComplianceSetup                
 SELECT @SourceAdviserRoleId = PractitionerRoleId, @SourceTnCCoachRoleId = TnCRoleId, @SourceFileCheckRoleId = FileCheckRoleId
 --fetching compliance grade role id from the source tenant
        , @SourceComplianceGradeRoleId = ComplianceGradeRoleId                
 FROM Compliance..TComplianceSetup                
 WHERE IndClientId = @SourceIndigoClientId                
                
 SELECT @AdviserRoleId = r1.RoleId                
 FROM TRole r1  WITH (NOLOCK)                
 JOIN TRole r2  WITH (NOLOCK) ON r1.Identifier = r2.Identifier                 
 WHERE r1.IndigoClientId = @IndigoClientId                
 AND r2.IndigoClientId = @SourceIndigoClientId                
 AND r2.RoleId = @SourceAdviserRoleId                
                
 SELECT @TnCCoachRoleId = r1.RoleId                
 FROM TRole r1 WITH (NOLOCK)                
 JOIN TRole r2 WITH (NOLOCK) ON r1.Identifier = r2.Identifier                 
 WHERE r1.IndigoClientId = @IndigoClientId                
 AND r2.IndigoClientId = @SourceIndigoClientId                
 AND r2.RoleId = @SourceTnCCoachRoleId                
                
 SELECT @FileCheckRoleId = r1.RoleId                
 FROM TRole r1 WITH (NOLOCK)                
 JOIN TRole r2 WITH (NOLOCK) ON r1.Identifier = r2.Identifier                 
 WHERE r1.IndigoClientId = @IndigoClientId                
 AND r2.IndigoClientId = @SourceIndigoClientId                
 AND r2.RoleId = @SourceFileCheckRoleId                
 
 --fetching compliance grade role id from TRole table for the new tenant
 SELECT @ComplianceGradeRoleId = r1.RoleId                
 FROM TRole r1 WITH (NOLOCK)                
 JOIN TRole r2 WITH (NOLOCK) ON r1.Identifier = r2.Identifier                 
 WHERE r1.IndigoClientId = @IndigoClientId                
 AND r2.IndigoClientId = @SourceIndigoClientId                
 AND r2.RoleId = @SourceComplianceGradeRoleId
 
 --update also includes the new complianceGradeRoleId column value also                
 UPDATE Compliance..TComplianceSetup                
 set PractitionerRoleId = @AdviserRoleId, TnCRoleId = @TnCCoachRoleId, FileCheckRoleId = @FileCheckRoleId ,  ComplianceGradeRoleId =  @ComplianceGradeRoleId               
 WHERE IndClientId = @IndigoClientId                
                
                 
--6. Copy lifecycles. This will also add the Statuses                
  exec PolicyManagement..SpCustomCopyLifeCycles @SourceIndigoClientId, @IndigoClientId                
                
--7. Plan Categories                
 INSERT INTO PolicyManagement..TPlanCategory ([PlanCategoryName],[RetireFg],[IndigoClientId],[Extensible],[ConcurrencyId])                
 VALUES('Non-Investment Insurance',0,@IndigoClientId,NULL,1)                
 INSERT INTO PolicyManagement..TPlanCategory ([PlanCategoryName],[RetireFg],[IndigoClientId],[Extensible],[ConcurrencyId])                
 VALUES('Non-Regulated',0,@IndigoClientId,NULL,1)                
 INSERT INTO PolicyManagement..TPlanCategory ([PlanCategoryName],[RetireFg],[IndigoClientId],[Extensible],[ConcurrencyId])                
 VALUES('Regulated Mortgage Contracts',0,@IndigoClientId,NULL,1)                
 INSERT INTO PolicyManagement..TPlanCategory ([PlanCategoryName],[RetireFg],[IndigoClientId],[Extensible],[ConcurrencyId])                
 VALUES('Retail Investments',0,@IndigoClientId,NULL,1)                
                
 INSERT INTO PolicyManagement..TRefPlanType2ProdSubTypeCategory (IndigoClientId, RefPlanType2ProdSubTypeId, PlanCategoryId, ConcurrencyId)              
 SELECT pc.IndigoClientId, pst.RefPlanType2ProdSubTypeId, pc.PlanCategoryId, 1              
 FROM PolicyManagement..TPlanCategory pc              
 JOIN PolicyManagement..TRefPlanType2ProdSubType pst ON pc.PlanCategoryName = pst.DefaultCategory              
 WHERE pc.IndigoClientId = @IndigoClientId              
                
              
           
                
                
--8. StatusReasons                
                
 set @MaxId = (select max(StatusReasonId) from PolicyManagement..TStatusReason)                
                
 INSERT INTO PolicyManagement..TStatusReason (Name, StatusId, OrigoStatusId, IntelligentOfficeStatusType, IndigoClientId, ConcurrencyId,RefLicenceTypeId)                
 SELECT sr.Name, new.StatusId, sr.OrigoStatusId, sr.IntelligentOfficeStatusType, @IndigoClientId, 1, sr.RefLicenceTypeId                
 FROM PolicyManagement..TStatusReason sr WITH (NOLOCK)                
 JOIN PolicyManagement..TStatus source ON source.StatusId = sr.StatusId                
 JOIN PolicyManagement..TStatus new ON new.Name = source.Name AND new.IndigoClientId = @IndigoClientId                
 WHERE sr.IndigoClientId = @SourceIndigoClientId                
                
 INSERT INTO PolicyManagement..TStatusReasonAudit (StatusId, Name, OrigoStatusId, IntelligentOfficeStatusType, IndigoClientId, ConcurrencyId, StatusReasonId, StampAction, StampDateTime, StampUser)                
 SELECT StatusId, Name, OrigoStatusId, IntelligentOfficeStatusType, IndigoClientId, ConcurrencyId, StatusReasonId, 'C', getdate(), 0                
 FROM PolicyManagement..TStatusReason                
 WHERE StatusReasonId > @MaxId               
                
 insert into PolicyManagement..tstatusreasonrole (StatusReasonId, RoleId)        
 select sr2.StatusReasonId, r2.RoleId        
 from PolicyManagement..tstatusreason sr1        
 join PolicyManagement..TStatusreasonrole srr on sr1.statusreasonid = srr.statusreasonid         
 join Administration..TRole r on r.roleid = srr.roleid        
 join PolicyManagement..TStatusReason sr2 ON sr1.Name = sr2.Name AND sr2.IndigoCLientId = @IndigoClientId        
 join administration..TRole r2 ON r2.Identifier = r.Identifier AND r2.IndigoClientId = @IndigoClientId        
 where sr1.indigoclientid = @SourceIndigoClientId        
                
--9. Plan Purposes  : 

--*********************************************
--Removed as this is now added from  PolicyManagement..spCustomCreatePlanPurposeForNewTenant             
--*********************************************
                
                
           
--10. Task setup                
                
 EXEC crm..SpCreateLeadStatus 0, 'Initial', 0, 1, @IndigoClientId                
 EXEC crm..SpCreateLeadStatus 0, 'Deferred', 0, 2, @IndigoClientId                
 EXEC crm..SpCreateLeadStatus 0, 'Qualified', 1, 3, @IndigoClientId                
 EXEC crm..SpCreateLeadStatus 0, 'Closed', 0, 4, @IndigoClientId                
                
                 
--11. Diary setup
-- RUI 28/06/2019: IP-55689 - It was adding Miscellaneous, but we want the default for Diary
/*
 exec crm..spCreateActivityCategoryParent '0','Miscellaneous',@IndigoClientId                
 select @MaxId=max(ActivityCategoryParentId) from crm..tactivitycategoryparent where IndigoClientId = @IndigoClientId
 exec crm..spCreateActivityCategory '0',  'Miscellaneous',  @MaxId,  0, @IndigoClientId, 1, 0, 0, 0, 0, 0, 'Diary'                
*/

declare
  @ActivityCategoryParentName varchar(50),
  @ActivityCategoryName varchar(50)

  select top 1 @ActivityCategoryParentName = a.[name],
    @ActivityCategoryName = b.[name]
  from crm..tActivityCategoryParent a
  inner join crm..tActivityCategory b on b.ActivityCategoryParentId = a.ActivityCategoryParentId and b.IndigoCLientId = a.IndigoCLientId
  where b.IndigoCLientId = @SourceIndigoClientId
    and b.ActivityEvent = 'Diary'

  -- Only add if it doesn't exist
  if @ActivityCategoryParentName is not null and exists(select 1 from crm..tActivityCategory where IndigoCLientId = @IndigoClientId and ActivityEvent = 'Diary') begin
    exec crm..spCreateActivityCategoryParent '0', @ActivityCategoryParentName, @IndigoClientId                
    select @MaxId=max(ActivityCategoryParentId) from crm..tactivitycategoryparent where IndigoClientId = @IndigoClientId
    exec crm..spCreateActivityCategory '0',  @ActivityCategoryName,  @MaxId,  0, @IndigoClientId, 1, 0, 0, 0, 0, 0, 'Diary'
  end

               
--12. Mortgage setup               
                
 exec PolicyManagement..spCreateRefMortgageRepaymentMethod 0,'Capital and Interest', @IndigoClientId                
 exec PolicyManagement..spCreateRefMortgageRepaymentMethod 0,'Interest Only/Endowment', @IndigoClientId                
 exec PolicyManagement..spCreateRefMortgageRepaymentMethod 0,'Interest Only/ISA', @IndigoClientId                
 exec PolicyManagement..spCreateRefMortgageRepaymentMethod 0,'Interest Only/Pension', @IndigoClientId                
 exec PolicyManagement..spCreateRefMortgageRepaymentMethod 0,'Interest Only/Other', @IndigoClientId                
 exec PolicyManagement..spCreateRefMortgageRepaymentMethod 0,'Split Repayment', @IndigoClientId                
 exec PolicyManagement..spCreateRefMortgageRepaymentMethod 0,'Interest Only/No Investment Vehicle', @IndigoClientId                        
 exec PolicyManagement..spCreateRefMortgageRepaymentMethod 0,'Interest Only', @IndigoClientId                
 exec PolicyManagement..spCreateRefMortgageRepaymentMethod 0,'Interest Only/Downsizing', @IndigoClientId                
 exec PolicyManagement..spCreateRefMortgageRepaymentMethod 0,'Interest Roll-up/Sale Of Property', @IndigoClientId                
 exec PolicyManagement..spCreateRefMortgageRepaymentMethod 0,'Interest Only/Sale Of Property', @IndigoClientId                
                                

    
GO
