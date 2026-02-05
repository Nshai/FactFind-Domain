SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomConfigureNewOrganisationFromRemote]    
@IndigoClientId bigint,    
@SourceIndigoClientId bigint,    
@SourceIndigoClientServer varchar(50)    
    
as    
    
begin    
    
declare @GroupingId bigint    
declare @MaxId bigint    
declare @sql varchar(8000), @sourceServer varchar(50)    
    
set @SourceServer = '[' + @SourceIndigoClientServer + ']'    
    
--1. get the Organisation grouping    
 SELECT @GroupingId = GroupingId FROM TGrouping  WITH (NOLOCK) WHERE IndigoClientId = @IndigoClientId    
    
    
--2. Copy roles from source organisation    
 set @MaxId = (select max(roleId) from tRole)    
    
 set @sql = '    
 INSERT INTO TRole (Identifier, GroupingId, SuperUser, IndigoClientId, LicensedUserCount, Dashboard, ShowGroupDashboard, ConcurrencyId)    
 SELECT Identifier, ' + convert(varchar(10),@GroupingId) + ', SuperUser, ' + convert(varchar(10),@IndigoClientId) + ', LicensedUserCount, Dashboard, ShowGroupDashboard, 1    
 FROM ' + @sourceServer + '.administration.dbo.TRole WITH (NOLOCK)    
 WHERE IndigoClientId = ' + convert(varchar(10),@SourceIndigoClientId) + '    
 AND Identifier NOT IN     
  (    
  SELECT Identifier FROM TRole WITH (NOLOCK) WHERE IndigoClientId = ' + convert(varchar(10),@IndigoClientId) + '    
  )    
 '    
 exec (@sql)    
    
 INSERT INTO TRoleAudit (Identifier, GroupingId, SuperUser, IndigoClientId, LicensedUserCount, Dashboard, ShowGroupDashboard, ConcurrencyId, RoleId, HasGroupDataAccess, StampAction, StampDateTime, StampUser)    
 SELECT Identifier, GroupingId, SuperUser, @IndigoClientId, LicensedUserCount, Dashboard, ShowGroupDashboard, ConcurrencyId, RoleId, HasGroupDataAccess, 'C', getdate(), 0    
 FROM TRole WITH (NOLOCK)    
 WHERE IndigoClientId = @IndigoClientId    
 AND RoleId > @MaxId    
    
     
     
    
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

set @sql = '
 INSERT INTO TKey(RightMask, SystemId, UserId, RoleId, ConcurrencyId)
 OUTPUT
    inserted.RightMask,
    inserted.SystemId,
    inserted.UserId,
    inserted.RoleId,
    inserted.ConcurrencyId,
    inserted.KeyId,
    ''C'',
    GETUTCDATE(),
    ''0''
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
 SELECT k.RightMask, ts.SystemId, null, new.RoleId, 1
 FROM ' + @sourceServer + '.administration.dbo.TKey k WITH (NOLOCK)
 JOIN ' + @sourceServer + '.administration.dbo.TSystem s ON s.SystemId = k.SystemId
 JOIN ' + @sourceServer + '.administration.dbo.TRole source  WITH (NOLOCK) ON source.RoleId = k.RoleId AND k.UserId IS NULL AND source.IndigoClientId = ' + convert(varchar(10),@SourceIndigoClientId) + '
 JOIN TRole new  WITH (NOLOCK) ON new.Identifier = source.Identifier AND new.IndigoClientId = ' + convert(varchar(10),@IndigoClientId) + '
 JOIN TSystem ts WITH (NOLOCK) ON ts.SystemPath = s.SystemPath '

exec(@sql)


--4. Copy report security keys - remove any existing keys first    
 DELETE FROM k    
 FROM Reporter..TReportKey k    
 JOIN TRole r ON r.RoleId = k.RoleId    
 WHERE r.IndigoClientId = @IndigoClientId    
    
 set @sql = '    
 INSERT INTO Reporter..TReportKey(RightMask, AdvancedMask, EntityId, UserId, RoleId, ConcurrencyId, IsCategory)    
 SELECT k.RightMask, k.AdvancedMask, k.EntityId, null, new.RoleId, 1, k.IsCategory    
 FROM ' + @sourceServer + '.Reporter.dbo.TReportKey k WITH (NOLOCK)    
 JOIN ' + @sourceServer + '.administration.dbo.TRole source  WITH (NOLOCK) ON source.RoleId = k.RoleId AND k.UserId IS NULL AND source.IndigoClientId = ' + convert(varchar(10),@SourceIndigoClientId) + '    
 JOIN TRole new  WITH (NOLOCK) ON new.Identifier = source.Identifier AND new.IndigoClientId = ' + convert(varchar(10),@IndigoClientId)    
    
 exec(@sql)    
    
    
--5. Get the Adviser and TnCCoach roles and update TComplianceSetup    
    
 set @sql = '    
  declare @AdviserRoleId bigint, @TnCCoachRoleId bigint, @FileCheckRoleId bigint    
  declare @SourceAdviserRoleId bigint, @SourceTnCCoachRoleId bigint, @SourceFileCheckRoleId bigint    
     
  SELECT     
  @SourceAdviserRoleId = PractitionerRoleId,     
  @SourceTnCCoachRoleId = TnCRoleId,     
  @SourceFileCheckRoleId = FileCheckRoleId    
  FROM ' + @sourceServer + '.Compliance.dbo.TComplianceSetup    
  WHERE IndClientId = ' + convert(varchar(10),@SourceIndigoClientId) + '    
    
    
  SELECT @AdviserRoleId = r1.RoleId    
  FROM TRole r1  WITH (NOLOCK)    
  JOIN ' + @sourceServer + '.Administration.dbo.TRole r2  WITH (NOLOCK) ON r1.Identifier = r2.Identifier     
  WHERE r1.IndigoClientId = ' + convert(varchar(10),@IndigoClientId) + '    
  AND r2.IndigoClientId = ' + convert(varchar(10),@SourceIndigoClientId) + '    
  AND r2.RoleId = @SourceAdviserRoleId    
    
  SELECT @TnCCoachRoleId = r1.RoleId    
  FROM TRole r1 WITH (NOLOCK)    
  JOIN ' + @sourceServer + '.Administration.dbo.TRole r2 WITH (NOLOCK) ON r1.Identifier = r2.Identifier     
  WHERE r1.IndigoClientId = ' + convert(varchar(10),@IndigoClientId) + '    
  AND r2.IndigoClientId = ' + convert(varchar(10),@SourceIndigoClientId) + '    
  AND r2.RoleId = @SourceTnCCoachRoleId    
    
  SELECT @FileCheckRoleId = r1.RoleId    
  FROM TRole r1 WITH (NOLOCK)    
  JOIN ' + @sourceServer + '.Administration.dbo.TRole r2 WITH (NOLOCK) ON r1.Identifier = r2.Identifier     
  WHERE r1.IndigoClientId = ' + convert(varchar(10),@IndigoClientId) + '    
  AND r2.IndigoClientId = ' + convert(varchar(10),@SourceIndigoClientId) + '    
  AND r2.RoleId = @SourceFileCheckRoleId    
    
    
  UPDATE Compliance..TComplianceSetup    
  set PractitionerRoleId = @AdviserRoleId, TnCRoleId = @TnCCoachRoleId, FileCheckRoleId = @FileCheckRoleId    
  WHERE IndClientId = ' + convert(varchar(10),@IndigoClientId)    
    
  exec(@sql)    
    
--6. Copy lifecycles. This will also add the Statuses    
 exec PolicyManagement..SpCustomCopyLifeCyclesFromRemote @SourceIndigoClientId, @IndigoClientId, @SourceIndigoClientServer    
    
--7. Plan Categories    
 INSERT INTO PolicyManagement..TPlanCategory ([PlanCategoryName],[RetireFg],[IndigoClientId],[Extensible],[ConcurrencyId])    
 VALUES('Pensions for savings',0,@IndigoClientId,NULL,1)    
 INSERT INTO PolicyManagement..TPlanCategory ([PlanCategoryName],[RetireFg],[IndigoClientId],[Extensible],[ConcurrencyId])    
 VALUES('Pensions for Protection',0,@IndigoClientId,NULL,1)    
 INSERT INTO PolicyManagement..TPlanCategory ([PlanCategoryName],[RetireFg],[IndigoClientId],[Extensible],[ConcurrencyId])    
 VALUES('Pensions for Income',0,@IndigoClientId,NULL,1)    
 INSERT INTO PolicyManagement..TPlanCategory ([PlanCategoryName],[RetireFg],[IndigoClientId],[Extensible],[ConcurrencyId])    
 VALUES('Savings / investments',0,@IndigoClientId,NULL,1)    
 INSERT INTO PolicyManagement..TPlanCategory ([PlanCategoryName],[RetireFg],[IndigoClientId],[Extensible],[ConcurrencyId])    
 VALUES('Protection and Life products',0,@IndigoClientId,NULL,1)    
 INSERT INTO PolicyManagement..TPlanCategory ([PlanCategoryName],[RetireFg],[IndigoClientId],[Extensible],[ConcurrencyId])    
 VALUES('Loans',0,@IndigoClientId,NULL,1)    
    
 exec PolicyManagement..SpCustomUpdatePlanCategories @IndigoClientId   
    
--8. StatusReasons    
    
 set @MaxId = (select max(StatusReasonId) from PolicyManagement..TStatusReason)    
    
 set @sql = '    
 INSERT INTO PolicyManagement..TStatusReason (Name, StatusId, OrigoStatusId, IntelligentOfficeStatusType, IndigoClientId, ConcurrencyId)    
 SELECT sr.Name, new.StatusId, sr.OrigoStatusId, sr.IntelligentOfficeStatusType, ' + convert(varchar(10),@IndigoClientId) + ', 1    
 FROM ' + @sourceServer + '.PolicyManagement.dbo.TStatusReason sr WITH (NOLOCK)    
 JOIN ' + @sourceServer + '.PolicyManagement.dbo.TStatus source ON source.StatusId = sr.StatusId    
 JOIN PolicyManagement..TStatus new ON new.Name = source.Name AND new.IndigoClientId = ' + convert(varchar(10),@IndigoClientId) + '    
 WHERE sr.IndigoClientId = ' + convert(varchar(10),@SourceIndigoClientId)    
     
 exec(@sql)    
    
 INSERT INTO PolicyManagement..TStatusReasonAudit (StatusId, Name, OrigoStatusId, IntelligentOfficeStatusType, IndigoClientId, ConcurrencyId, StatusReasonId, StampAction, StampDateTime, StampUser)    
 SELECT StatusId, Name, OrigoStatusId, IntelligentOfficeStatusType, IndigoClientId, ConcurrencyId, StatusReasonId, 'C', getdate(), 0    
 FROM PolicyManagement..TStatusReason    
 WHERE StatusReasonId > @MaxId    
     
 -- StatusReasonRoles    
    
 set @sql = '    
 insert into PolicyManagement..tstatusreasonrole (StatusReasonId, RoleId)    
 select sr2.StatusReasonId, r2.RoleId    
 from ' + @sourceServer + '.PolicyManagement.dbo.tstatusreason sr1    
 join ' + @sourceServer + '.PolicyManagement.dbo.TStatusreasonrole srr on sr1.statusreasonid = srr.statusreasonid     
 join ' + @sourceServer + '.administration.dbo.TRole r on r.roleid = srr.roleid    
 join PolicyManagement..TStatusReason sr2 ON sr1.Name = sr2.Name AND sr2.IndigoCLientId = ' + convert(varchar(10),@IndigoClientId) + '    
 join administration..TRole r2 ON r2.Identifier = r.Identifier AND r2.IndigoClientId = ' + convert(varchar(10),@IndigoClientId) + '    
 where sr1.indigoclientid = ' + convert(varchar(10),@SourceIndigoClientId)    
    
 exec(@sql)    
    
--9. Plan Purposes    
    
 Declare @RetirementPlanning bigint, @MortgageRepayment bigint, @Concurrancy bigint, @PropertyPurchase bigint    
 Declare @PensionFundWithdrawl bigint, @ExternalFundManagement bigint, @Growth bigint, @Income bigint    
 Declare @GrowthandIncome bigint, @Savings bigint, @Protection bigint, @IHTPlanning bigint, @Residential bigint    
 Declare @Commercial bigint, @BuytoLet bigint, @SchoolFees bigint    
     
     
 INSERT INTO PolicyManagement..TPlanPurpose ([Descriptor],[MortgageRelatedfg],[IndigoClientId],[ConcurrencyId])VALUES('Retirement Planning',NULL,@IndigoClientId,1)    
 SELECT @RetirementPlanning= IDENT_CURRENT('PolicyManagement..TPlanPurpose')    
     
 INSERT INTO PolicyManagement..TPlanPurpose ([Descriptor],[MortgageRelatedfg],[IndigoClientId],[ConcurrencyId])VALUES('Mortgage Repayment',NULL,@IndigoClientId,1)    
 SELECT @MortgageRepayment=  IDENT_CURRENT('PolicyManagement..TPlanPurpose')    
     
 INSERT INTO PolicyManagement..TPlanPurpose ([Descriptor],[MortgageRelatedfg],[IndigoClientId],[ConcurrencyId])VALUES('Concurrancy',NULL,@IndigoClientId,1)    
 SELECT @Concurrancy =  IDENT_CURRENT('PolicyManagement..TPlanPurpose')    
     
 INSERT INTO PolicyManagement..TPlanPurpose ([Descriptor],[MortgageRelatedfg],[IndigoClientId],[ConcurrencyId])VALUES('Property Purchase',NULL,@IndigoClientId,1)    
 SELECT @PropertyPurchase =  IDENT_CURRENT('PolicyManagement..TPlanPurpose')    
     
 INSERT INTO PolicyManagement..TPlanPurpose ([Descriptor],[MortgageRelatedfg],[IndigoClientId],[ConcurrencyId])VALUES('Pension Fund Withdrawl',NULL,@IndigoClientId,1)    
 SELECT @PensionFundWithdrawl =  IDENT_CURRENT('PolicyManagement..TPlanPurpose')    
     
 INSERT INTO PolicyManagement..TPlanPurpose ([Descriptor],[MortgageRelatedfg],[IndigoClientId],[ConcurrencyId])VALUES('External Fund Management',NULL,@IndigoClientId,1)    
 SELECT @ExternalFundManagement =  IDENT_CURRENT('PolicyManagement..TPlanPurpose')    
     
 INSERT INTO PolicyManagement..TPlanPurpose ([Descriptor],[MortgageRelatedfg],[IndigoClientId],[ConcurrencyId])VALUES('Growth',NULL,@IndigoClientId,1)    
 SELECT @Growth =  IDENT_CURRENT('PolicyManagement..TPlanPurpose')    
     
 INSERT INTO PolicyManagement..TPlanPurpose ([Descriptor],[MortgageRelatedfg],[IndigoClientId],[ConcurrencyId])VALUES('Income',NULL,@IndigoClientId,1)    
 SELECT @Income =  IDENT_CURRENT('PolicyManagement..TPlanPurpose')    
     
 INSERT INTO PolicyManagement..TPlanPurpose ([Descriptor],[MortgageRelatedfg],[IndigoClientId],[ConcurrencyId])VALUES('Growth and Income',NULL,@IndigoClientId,1)    
 SELECT @GrowthandIncome =  IDENT_CURRENT('PolicyManagement..TPlanPurpose')    
     
 INSERT INTO PolicyManagement..TPlanPurpose ([Descriptor],[MortgageRelatedfg],[IndigoClientId],[ConcurrencyId])VALUES('Savings',NULL,@IndigoClientId,1)    
 SELECT @Savings =  IDENT_CURRENT('PolicyManagement..TPlanPurpose')    
     
 INSERT INTO PolicyManagement..TPlanPurpose ([Descriptor],[MortgageRelatedfg],[IndigoClientId],[ConcurrencyId])VALUES('Protection',NULL,@IndigoClientId,1)    
 SELECT @Protection =  IDENT_CURRENT('PolicyManagement..TPlanPurpose')    
     
 INSERT INTO PolicyManagement..TPlanPurpose ([Descriptor],[MortgageRelatedfg],[IndigoClientId],[ConcurrencyId])VALUES('IHT  Planning',NULL,@IndigoClientId,1)    
 SELECT @IHTPlanning =  IDENT_CURRENT('PolicyManagement..TPlanPurpose')    
     
 INSERT INTO PolicyManagement..TPlanPurpose ([Descriptor],[MortgageRelatedfg],[IndigoClientId],[ConcurrencyId])VALUES('Residential',NULL,@IndigoClientId,1)    
 SELECT @Residential =  IDENT_CURRENT('PolicyManagement..TPlanPurpose')    
     
 INSERT INTO PolicyManagement..TPlanPurpose ([Descriptor],[MortgageRelatedfg],[IndigoClientId],[ConcurrencyId])VALUES('Commercial',NULL,@IndigoClientId,1)    
 SELECT @Commercial =  IDENT_CURRENT('PolicyManagement..TPlanPurpose')    
     
 INSERT INTO PolicyManagement..TPlanPurpose ([Descriptor],[MortgageRelatedfg],[IndigoClientId],[ConcurrencyId])VALUES('Buy to Let',NULL,@IndigoClientId,1)    
 SELECT @BuytoLet =  IDENT_CURRENT('PolicyManagement..TPlanPurpose')    
     
 INSERT INTO PolicyManagement..TPlanPurpose ([Descriptor],[MortgageRelatedfg],[IndigoClientId],[ConcurrencyId])VALUES('School Fees',NULL,@IndigoClientId,1)    
 SELECT @SchoolFees =  IDENT_CURRENT('PolicyManagement..TPlanPurpose')    
     
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(2,@RetirementPlanning,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(3,@RetirementPlanning,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(5,@RetirementPlanning,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(6,@RetirementPlanning,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(8,@RetirementPlanning,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(1,@RetirementPlanning,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(7,@RetirementPlanning,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(18,@RetirementPlanning,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(2,@MortgageRepayment,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(5,@MortgageRepayment,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(6,@MortgageRepayment,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(8,@MortgageRepayment,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(3,@MortgageRepayment,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(26,@MortgageRepayment,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(27,@MortgageRepayment,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(31,@MortgageRepayment,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(31,@Growth,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(31,@Income,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(31,@GrowthandIncome,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(32,@MortgageRepayment,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(41,@MortgageRepayment,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(42,@MortgageRepayment,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(44,@MortgageRepayment,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(46,@MortgageRepayment,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(39,@MortgageRepayment,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(62,@MortgageRepayment,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(18,@MortgageRepayment,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(2,@Concurrancy,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(3,@Concurrancy,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(5,@Concurrancy,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(6,@Concurrancy,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(8,@Concurrancy,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(18,@Concurrancy,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(1,@PropertyPurchase,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(6,@PropertyPurchase,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(7,@PropertyPurchase,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(1,@PensionFundWithdrawl,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(6,@PensionFundWithdrawl,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(7,@PensionFundWithdrawl,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(1,@ExternalFundManagement,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(6,@ExternalFundManagement,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(7,@ExternalFundManagement,1)    
 INSERT INTO PolicyManagement..TPlanTypePurpose ([RefPlanTypeId],[PlanPurposeId],[ConcurrencyId])VALUES(26,@Growth,1)    
     
    
--10. Task setup    
    
 EXEC crm..SpCreateLeadStatus 0, 'Initial', 0, 1, @IndigoClientId    
 EXEC crm..SpCreateLeadStatus 0, 'Deferred', 0, 2, @IndigoClientId    
 EXEC crm..SpCreateLeadStatus 0, 'Qualified', 1, 3, @IndigoClientId    
 EXEC crm..SpCreateLeadStatus 0, 'Closed', 0, 4, @IndigoClientId    
    
     
--11. Diary setup    
 exec crm..spCreateActivityCategoryParent '0','Miscellaneous',@IndigoClientId    
 select @MaxId=max(ActivityCategoryParentId) from crm..tactivitycategoryparent    
 exec crm..spCreateActivityCategory '0',  'Miscellaneous',  @MaxId,  0, @IndigoClientId, 1, 0, 0, 0, 0, 0, 'Diary'    
    
    
    
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

end
GO
