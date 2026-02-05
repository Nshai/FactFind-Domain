SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCloneAdviserCharging] @IndigoClientId int, @SourceIndigoClientId int, @StampUser varchar(255) = '-1010'
as
begin
-- REQUIRES of dbo.spCloneServiceCase to run first

-- Adviser charging & Fee model. Changes made to each area of the adviser charging tab, including a standard fee model and tenant configuration
-- Administration > Organisation > Adviser Charging > Fee Model
-- Administration > Organisation > Adviser Charging > Fee Model >> OPEN
-- Administration > Organisation > Adviser Charging > Tenant Configuration
	set nocount on
	declare @ProcName sysname = OBJECT_NAME(@@PROCID),
		@procResult int
	exec @procResult = dbo.spStartCreateTenantModule @IndigoClientId, @SourceIndigoClientId, @ProcName
	if @procResult!=0 return

	declare @tx int,
		@Now datetime = GetDate(),
		@msg varchar(max)

	declare @IO_MigrationRef varchar(max) ='',
		@FeeModelTemplateId int

	select @tx = @@TRANCOUNT

	if @tx = 0 begin
		set @msg=@ProcName+': begin transaction TX'
		raiserror(@msg,0,1) with nowait
		begin transaction TX
	end

	begin try
		update a
		set a.IsConfigured = b.IsConfigured,
			a.ConcurrencyId +=1
		output
			inserted.TenantRuleConfigurationId, inserted.RefRuleConfigurationId, inserted.IsConfigured, inserted.TenantId, inserted.ConcurrencyId
			,'U', @Now, @StampUser
		into PolicyManagement.dbo.TTenantRuleConfigurationAudit(TenantRuleConfigurationId, RefRuleConfigurationId, IsConfigured, TenantId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from PolicyManagement.dbo.TTenantRuleConfiguration a
		inner join PolicyManagement.dbo.TTenantRuleConfiguration b on b.RefRuleConfigurationId = a.RefRuleConfigurationId and b.TenantId = @SourceIndigoClientId
		where a.TenantId = @IndigoClientId
			and a.IsConfigured != b.IsConfigured

		insert into PolicyManagement.dbo.TTenantRuleConfiguration(RefRuleConfigurationId, IsConfigured, TenantId, ConcurrencyId)
		output
			inserted.TenantRuleConfigurationId, inserted.RefRuleConfigurationId, inserted.IsConfigured, inserted.TenantId, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into PolicyManagement.dbo.TTenantRuleConfigurationAudit(TenantRuleConfigurationId, RefRuleConfigurationId, IsConfigured, TenantId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)

		select RefRuleConfigurationId, IsConfigured, @IndigoClientId, 1
		from PolicyManagement.dbo.TTenantRuleConfiguration
		where TenantId = @SourceIndigoClientId
		except
		select RefRuleConfigurationId, IsConfigured, TenantId, 1
		from PolicyManagement.dbo.TTenantRuleConfiguration
		where TenantId = @IndigoClientId

		---**************************************
		-- TEventListTemplate
		update a
		set a.AllowAddTaskFg = b.AllowAddTaskFg,
			a.ClientRelatedFg = b.ClientRelatedFg,
			a.PlanRelatedFg = b.PlanRelatedFg,
			a.LeadRelatedFg = b.LeadRelatedFg,
			a.AdviserRelatedFg = b.AdviserRelatedFg,
			a.SchemeRelatedFg = b.SchemeRelatedFg,
			a.IsArchived = b.IsArchived,
			a.ServiceCaseRelatedFg = b.ServiceCaseRelatedFg,
			a.IsPropagated = b.IsPropagated,
			a.ConcurrencyId += 1
		output
			inserted.EventListTemplateId,
			inserted.[Name],
			inserted.AllowAddTaskFg,
			inserted.IndigoClientId,
			inserted.ClientRelatedFg,
			inserted.PlanRelatedFg,
			inserted.LeadRelatedFg,
			inserted.AdviserRelatedFg,
			inserted.SchemeRelatedFg,
			inserted.ConcurrencyId,
			inserted.IsArchived,
			inserted.GroupId,
			inserted.ServiceCaseRelatedFg,
			inserted.IsPropagated
			,'U', @Now, @StampUser
		into crm.dbo.TEventListTemplateAudit(
			EventListTemplateId,
			[Name],
			AllowAddTaskFg,
			IndigoClientId,
			ClientRelatedFg,
			PlanRelatedFg,
			LeadRelatedFg,
			AdviserRelatedFg,
			SchemeRelatedFg,
			ConcurrencyId,
			IsArchived,
			GroupId,
			ServiceCaseRelatedFg,
			IsPropagated
			, StampAction, StampDateTime, StampUser)
		from crm.dbo.TEventListTemplate a
			inner join crm.dbo.TEventListTemplate b on b.[Name] = a.[Name] and b.IndigoClientId = @SourceIndigoClientId
		where b.ServiceCaseRelatedFg = 1 and b.GroupId is null
			and (a.AllowAddTaskFg != b.AllowAddTaskFg
			or a.ClientRelatedFg != b.ClientRelatedFg
			or a.PlanRelatedFg != b.PlanRelatedFg
			or a.LeadRelatedFg != b.LeadRelatedFg
			or a.AdviserRelatedFg != b.AdviserRelatedFg
			or a.SchemeRelatedFg != b.SchemeRelatedFg
			or a.IsArchived != b.IsArchived
			or a.ServiceCaseRelatedFg != b.ServiceCaseRelatedFg
			or a.IsPropagated != b.IsPropagated
			)

		insert into crm.dbo.TEventListTemplate(
			[Name],
			AllowAddTaskFg,
			IndigoClientId,
			ClientRelatedFg,
			PlanRelatedFg,
			LeadRelatedFg,
			AdviserRelatedFg,
			SchemeRelatedFg,
			ConcurrencyId,
			IsArchived,
			GroupId,
			ServiceCaseRelatedFg)
		output
			inserted.EventListTemplateId,
			inserted.[Name],
			inserted.AllowAddTaskFg,
			inserted.IndigoClientId,
			inserted.ClientRelatedFg,
			inserted.PlanRelatedFg,
			inserted.LeadRelatedFg,
			inserted.AdviserRelatedFg,
			inserted.SchemeRelatedFg,
			inserted.ConcurrencyId,
			inserted.IsArchived,
			inserted.GroupId,
			inserted.ServiceCaseRelatedFg,
			inserted.IsPropagated
			,'C', @Now, @StampUser
		into crm.dbo.TEventListTemplateAudit(
			EventListTemplateId,
			[Name],
			AllowAddTaskFg,
			IndigoClientId,
			ClientRelatedFg,
			PlanRelatedFg,
			LeadRelatedFg,
			AdviserRelatedFg,
			SchemeRelatedFg,
			ConcurrencyId,
			IsArchived,
			GroupId,
			ServiceCaseRelatedFg,
			IsPropagated
			, StampAction, StampDateTime, StampUser)

		select
			[Name],
			AllowAddTaskFg,
			@IndigoClientId,
			ClientRelatedFg,
			PlanRelatedFg,
			LeadRelatedFg,
			AdviserRelatedFg,
			SchemeRelatedFg,
			1,
			IsArchived,
			GroupId,
			ServiceCaseRelatedFg
		from crm.dbo.TEventListTemplate
		where IndigoClientId = @SourceIndigoClientId
			and ServiceCaseRelatedFg = 1
			and GroupId is null
		except
		select
			[Name],
			AllowAddTaskFg,
			IndigoClientId,
			ClientRelatedFg,
			PlanRelatedFg,
			LeadRelatedFg,
			AdviserRelatedFg,
			SchemeRelatedFg,
			1,
			IsArchived,
			GroupId,
			ServiceCaseRelatedFg
		from crm.dbo.TEventListTemplate
		where IndigoClientId = @IndigoClientId
			and ServiceCaseRelatedFg = 1
			and GroupId is null


		-- Organisation > Adviser Charging > Fee Model

		update a
		set a.StartDate = b.StartDate,
			a.EndDate = b.EndDate,
			a.IsDefault = b.IsDefault,
			a.IsArchived = b.IsArchived,
			a.IsPropagated = b.IsPropagated,
			a.RefFeeModelStatusId = b.RefFeeModelStatusId,
			a.ConcurrencyId += 1
		output
			inserted.FeeModelId,
			inserted.[Name],
			inserted.StartDate,
			inserted.EndDate,
			inserted.RefFeeModelStatusId,
			inserted.IsDefault,
			inserted.IsArchived,
			inserted.TenantId,
			inserted.ConcurrencyId,
			inserted.GroupId,
			inserted.IsPropagated,
			inserted.IsSystemDefined
			,'U', @Now, @StampUser
		into
			PolicyManagement.dbo.TFeeModelAudit(
			FeeModelId,
			[Name],
			StartDate,
			EndDate,
			RefFeeModelStatusId,
			IsDefault,
			IsArchived,
			TenantId,
			ConcurrencyId,
			GroupId,
			IsPropagated,
			IsSystemDefined
			, StampAction, StampDateTime, StampUser)
		from PolicyManagement.dbo.TFeeModel a
			inner join PolicyManagement.dbo.TFeeModel b on b.[Name] = a.[Name] and b.TenantId = @SourceIndigoClientId
			--left join Administration.dbo.TGroup ga on ga.GroupId = a.GroupId and ga.IndigoClientId = @IndigoClientId
			--left join Administration.dbo.TGroup gb on gb.GroupId = b.GroupId and gb.IndigoClientId = @SourceIndigoClientId
		where a.TenantId = @IndigoClientId
			--and isnull(ga.Identifier,'') = isnull(gb.Identifier,'')
			and a.GroupId is null
			and b.GroupId is null
			and b.IsSystemDefined = a.IsSystemDefined -- No change
			and (a.RefFeeModelStatusId != b.RefFeeModelStatusId
				or isnull(a.StartDate, @Now) != isnull(b.StartDate, @Now)
				or isnull(a.EndDate, @Now) != isnull(b.EndDate, @Now)
				or a.IsDefault != b.IsDefault
				or a.IsArchived != b.IsArchived
				or a.IsPropagated != b.IsPropagated
				)
			and a.IsSystemDefined = 0 and b.IsSystemDefined = 0

		insert into PolicyManagement.dbo.TFeeModel([Name],
			StartDate,
			EndDate,
			RefFeeModelStatusId,
			IsDefault,
			IsArchived,
			TenantId,
			ConcurrencyId,
			GroupId,
			IsPropagated,
			IsSystemDefined)
		output
			inserted.FeeModelId,
			inserted.[Name],
			inserted.StartDate,
			inserted.EndDate,
			inserted.RefFeeModelStatusId,
			inserted.IsDefault,
			inserted.IsArchived,
			inserted.TenantId,
			inserted.ConcurrencyId,
			inserted.GroupId,
			inserted.IsPropagated,
			inserted.IsSystemDefined
			,'C', @Now, @StampUser
		into
			PolicyManagement.dbo.TFeeModelAudit(
			FeeModelId,
			[Name],
			StartDate,
			EndDate,
			RefFeeModelStatusId,
			IsDefault,
			IsArchived,
			TenantId,
			ConcurrencyId,
			GroupId,
			IsPropagated,
			IsSystemDefined
			, StampAction, StampDateTime, StampUser)

		select [Name],
			StartDate,
			EndDate,
			RefFeeModelStatusId,
			IsDefault,
			IsArchived,
			@IndigoClientId,
			1,
			GroupId,
			IsPropagated,
			IsSystemDefined
		from PolicyManagement.dbo.TFeeModel a
			--left join Administration.dbo.TGroup ga on ga.GroupId = a.GroupId and ga.IndigoClientId = @SourceIndigoClientId
			--left join Administration.dbo.TGroup gTgt on gTgt.Identifier = ga.Identifier and gTgt.IndigoClientId = @IndigoClientId
		where a.TenantId = @SourceIndigoClientId
			and a.GroupId is null
			and a.IsSystemDefined = 0
		except
		select [Name],
			StartDate,
			EndDate,
			RefFeeModelStatusId,
			IsDefault,
			IsArchived,
			TenantId,
			1,
			GroupId,
			IsPropagated,
			IsSystemDefined
		from PolicyManagement.dbo.TFeeModel
		where TenantId = @IndigoClientId
			and GroupId is null

		-- TFeeModelToRole

		delete a
		output
			deleted.FeeModelToRoleId, deleted.FeeModelId, deleted.RoleId, deleted.TenantId, deleted.ConcurrencyId
			,'D', @Now, @StampUser
		into PolicyManagement.dbo.TFeeModelToRoleAudit(
			FeeModelToRoleId, FeeModelId, RoleId, TenantId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from PolicyManagement.dbo.TFeeModelToRole a
			inner join PolicyManagement.dbo.TFeeModel b on b.FeeModelId = a.FeeModelId and b.TenantId = @IndigoClientId
			inner join Administration.dbo.TRole c on c.RoleId = a.RoleId and c.IndigoClientId = @IndigoClientId
		where a.TenantId = @IndigoClientId
			and not exists (select 1 from PolicyManagement.dbo.TFeeModelToRole d
				inner join PolicyManagement.dbo.TFeeModel e on e.FeeModelId = d.FeeModelId and e.TenantId = @SourceIndigoClientId
				inner join Administration.dbo.TRole f on f.RoleId = d.RoleId and c.IndigoClientId = @SourceIndigoClientId
				where d.TenantId = @SourceIndigoClientId
				and e.[Name] = b.[Name]
				and f.Identifier = c.Identifier
			)

		insert into PolicyManagement.dbo.TFeeModelToRole(FeeModelId, RoleId, TenantId, ConcurrencyId)
		output
			inserted.FeeModelToRoleId, inserted.FeeModelId, inserted.RoleId, inserted.TenantId, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into PolicyManagement.dbo.TFeeModelToRoleAudit(
			FeeModelToRoleId, FeeModelId, RoleId, TenantId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select fm.FeeModelId, r.RoleId, @IndigoClientId, 1
		from PolicyManagement.dbo.TFeeModelToRole a
			inner join Administration.dbo.TRole b on b.RoleId = a.RoleId and b.IndigoClientId = @SourceIndigoClientId
			inner join PolicyManagement.dbo.TFeeModel c on c.FeeModelId = a.FeeModelId and c.TenantId = @SourceIndigoClientId

			inner join Administration.dbo.TRole r on r.Identifier = b.Identifier and r.IndigoClientId = @IndigoClientId
			inner join PolicyManagement.dbo.TFeeModel fm on fm.[Name] = c.[Name] and fm.TenantId = @IndigoClientId
		where a.TenantId = @SourceIndigoClientId
		except
		select FeeModelId, RoleId, TenantId, 1
		from PolicyManagement.dbo.TFeeModelToRole
		where TenantId = @IndigoClientId


		update a
		set a.IsArchived = b.IsArchived,
			a.IsPropagated = b.IsPropagated,
			a.ConcurrencyId+=1
		output
			inserted.AdviseCategoryId, inserted.[Name], inserted.TenantId, inserted.IsArchived, inserted.ConcurrencyId, inserted.GroupId, inserted.IsPropagated
			,'U', @Now, @StampUser
		into PolicyManagement.dbo.TAdviseCategoryAudit(AdviseCategoryId, [Name], TenantId, IsArchived, ConcurrencyId, GroupId, IsPropagated
			, StampAction, StampDateTime, StampUser)
		from PolicyManagement.dbo.TAdviseCategory a
			--left join Administration.dbo.TGroup ga on ga.GroupId = a.GroupId and ga.IndigoClientId = @IndigoClientId
			inner join PolicyManagement.dbo.TAdviseCategory b on b.[Name] = a.[Name] and b.TenantId = @SourceIndigoClientId
			--left join Administration.dbo.TGroup gb on gb.GroupId = b.GroupId and gb.IndigoClientId = @SourceIndigoClientId
		where a.TenantId = @IndigoClientId
			--and isnull(ga.Identifier,'') = isnull(gb.Identifier,'')
			and a.GroupId is null and b.GroupId is null
			and (a.IsArchived != b.IsArchived or a.IsPropagated != b.IsPropagated)

		insert into PolicyManagement.dbo.TAdviseCategory([Name], TenantId, IsArchived, ConcurrencyId, GroupId, IsPropagated)
		output
			inserted.AdviseCategoryId, inserted.[Name], inserted.TenantId, inserted.IsArchived, inserted.ConcurrencyId, inserted.GroupId, inserted.IsPropagated
			,'C', @Now, @StampUser
		into PolicyManagement.dbo.TAdviseCategoryAudit(AdviseCategoryId, [Name], TenantId, IsArchived, ConcurrencyId, GroupId, IsPropagated
			, StampAction, StampDateTime, StampUser)

		select [Name], @IndigoClientId, IsArchived, 1, GroupId, IsPropagated
		from PolicyManagement.dbo.TAdviseCategory a
			--left join Administration.dbo.TGroup ga on ga.GroupId = a.GroupId and ga.IndigoClientId = @SourceIndigoClientId
			--left join Administration.dbo.TGroup gTgt on gTgt.Identifier = ga.Identifier and gTgt.IndigoClientId = @IndigoClientId
		where TenantId = @SourceIndigoClientId
			and GroupId is null
		except
		select [Name], TenantId, IsArchived, 1, GroupId, IsPropagated
		from PolicyManagement.dbo.TAdviseCategory
		where TenantId = @IndigoClientId
			and GroupId is null

		-- TAdviseCategoryToEventListTemplate
		delete a
		output
			deleted.AdviseCategoryToEventListTemplateId, deleted.AdviseCategoryId, deleted.EventListTemplateId, deleted.ConcurrencyId
			,'D', @Now, @StampUser
		into CRM.dbo.TAdviseCategoryToEventListTemplateAudit(
			AdviseCategoryToEventListTemplateId, AdviseCategoryId, EventListTemplateId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from CRM.dbo.TAdviseCategoryToEventListTemplate a
			inner join PolicyManagement.dbo.TAdviseCategory b on b.AdviseCategoryId = a.AdviseCategoryId
			inner join crm.dbo.TEventListTemplate c on c.EventListTemplateId = a.EventListTemplateId and c.IndigoClientId = @IndigoClientId
		where b.TenantId = @IndigoClientId
			and not exists(select 1 from CRM.dbo.TAdviseCategoryToEventListTemplate a2
			inner join PolicyManagement.dbo.TAdviseCategory b2 on b2.AdviseCategoryId = a2.AdviseCategoryId
			inner join crm.dbo.TEventListTemplate c2 on c2.EventListTemplateId = a2.EventListTemplateId and c2.IndigoClientId = @SourceIndigoClientId
			where b2.TenantId = @SourceIndigoClientId
				and b2.[Name] = b.[Name]
				and c2.[Name] = c.[Name]
				)

		insert into crm.dbo.TAdviseCategoryToEventListTemplate(AdviseCategoryId, EventListTemplateId, ConcurrencyId)
		output
			inserted.AdviseCategoryToEventListTemplateId, inserted.AdviseCategoryId, inserted.EventListTemplateId, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into crm.dbo.TAdviseCategoryToEventListTemplateAudit(AdviseCategoryToEventListTemplateId, AdviseCategoryId, EventListTemplateId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)

		select actrgt.AdviseCategoryId, elttrgt.EventListTemplateId, 1
		from crm.dbo.TAdviseCategoryToEventListTemplate a
		inner join PolicyManagement.dbo.TAdviseCategory acsrc on acsrc.AdviseCategoryId = a.AdviseCategoryId and acsrc.TenantId = @SourceIndigoClientId
			--left join Administration.dbo.TGroup gacsrc on gacsrc.GroupId = acsrc.GroupId and gacsrc.IndigoClientId = @SourceIndigoClientId
		inner join crm.dbo.TEventListTemplate eltsrc on eltsrc.EventListTemplateId = a.EventListTemplateId and eltsrc.IndigoClientId = @SourceIndigoClientId
			--left join Administration.dbo.TGroup geltsrc on geltsrc.GroupId = eltsrc.GroupId and geltsrc.IndigoClientId = @SourceIndigoClientId

		inner join PolicyManagement.dbo.TAdviseCategory actrgt on actrgt.[Name] = acsrc.[Name] and actrgt.TenantId = @IndigoClientId
			--left join Administration.dbo.TGroup gactrgt on gactrgt.GroupId = actrgt.GroupId and gactrgt.IndigoClientId = @IndigoClientId
		inner join crm.dbo.TEventListTemplate elttrgt on elttrgt.[Name] = eltsrc.[Name] and elttrgt.IndigoClientId = @IndigoClientId
			--left join Administration.dbo.TGroup gelttrgt on gelttrgt.GroupId = elttrgt.GroupId and gelttrgt.IndigoClientId = @IndigoClientId
		where
			--isnull(gacsrc.Identifier,'') = isnull(gactrgt.Identifier,'')
			--and isnull(geltsrc.Identifier,'') = isnull(gelttrgt.Identifier,'')
			acsrc.GroupId is null and eltsrc.GroupId is null
			and actrgt.GroupId is null and elttrgt.GroupId is null
			and eltsrc.ServiceCaseRelatedFg = 1
			and elttrgt.ServiceCaseRelatedFg = 1
		except
		select a.AdviseCategoryId, a.EventListTemplateId, 1
		from crm.dbo.TAdviseCategoryToEventListTemplate a
		inner join PolicyManagement.dbo.TAdviseCategory b on b.AdviseCategoryId = a.AdviseCategoryId and b.TenantId = @IndigoClientId
		inner join crm.dbo.TEventListTemplate c on c.EventListTemplateId = a.EventListTemplateId and c.IndigoClientId = @IndigoClientId

		--Adviser Charging > Fee Type

		--select * from PolicyManagement.dbo.TRefAdviseFeeType
		--select * from policymanagement.dbo.TAdviseFeeType where TenantId = 99 --and IsSystemDefined = 1

		update a
		set a.IsArchived = b.IsArchived,
			a.IsRecurring = b.IsRecurring,
			a.ConcurrencyId +=1
		output
			inserted.AdviseFeeTypeId, inserted.[Name], inserted.TenantId, inserted.IsArchived, inserted.ConcurrencyId, inserted.IsRecurring, inserted.GroupId, inserted.RefAdviseFeeTypeId, inserted.IsSystemDefined
			,'U', @Now, @StampUser
		into
			policymanagement.dbo.TAdviseFeeTypeAudit(AdviseFeeTypeId, [Name], TenantId, IsArchived, ConcurrencyId, IsRecurring, GroupId, RefAdviseFeeTypeId, IsSystemDefined
			, StampAction, StampDateTime, StampUser)
		from policymanagement.dbo.TAdviseFeeType a
		inner join policymanagement.dbo.TAdviseFeeType b on b.[Name] = a.[Name] and b.RefAdviseFeeTypeId = a.RefAdviseFeeTypeId and b.TenantId = @SourceIndigoClientId
		where a.TenantId = @IndigoClientId
			and a.GroupId is null
			and b.GroupId is null
			and a.IsSystemDefined = b.IsSystemDefined
			and (a.IsArchived != b.IsArchived
				or a.IsRecurring != b.IsRecurring)


		insert into policymanagement.dbo.TAdviseFeeType([Name], TenantId, IsArchived, ConcurrencyId, IsRecurring, GroupId, RefAdviseFeeTypeId, IsSystemDefined)
		output
			inserted.AdviseFeeTypeId, inserted.[Name], inserted.TenantId, inserted.IsArchived, inserted.ConcurrencyId, inserted.IsRecurring, inserted.GroupId, inserted.RefAdviseFeeTypeId, inserted.IsSystemDefined
			,'C', @Now, @StampUser
		into
			policymanagement.dbo.TAdviseFeeTypeAudit(AdviseFeeTypeId, [Name], TenantId, IsArchived, ConcurrencyId, IsRecurring, GroupId, RefAdviseFeeTypeId, IsSystemDefined
			, StampAction, StampDateTime, StampUser)

		select [Name], @IndigoClientId, IsArchived, 1, IsRecurring, GroupId, RefAdviseFeeTypeId, IsSystemDefined
		from policymanagement.dbo.TAdviseFeeType
		where TenantId = @SourceIndigoClientId
			and GroupId is null
		except
		select [Name], TenantId, IsArchived, 1, IsRecurring, GroupId, RefAdviseFeeTypeId, IsSystemDefined
		from policymanagement.dbo.TAdviseFeeType
		where TenantId = @IndigoClientId
			and GroupId is null

		--Adviser Charging > Payment Type

		--select * from Policymanagement.dbo.TRefAdvisePaidBy
		--select * from Policymanagement.dbo.TAdvisePaymentType where TenantId = 99

		update a
		set a.RefAdvisePaidById = b.RefAdvisePaidById,
			ConcurrencyId+=1
		output
			inserted.AdvisePaymentTypeId, inserted.TenantId, inserted.IsArchived, inserted.ConcurrencyId, inserted.[Name], inserted.IsSystemDefined, inserted.GroupId, inserted.RefAdvisePaidById, inserted.PaymentProviderId
			,'U', @Now, @StampUser
		into Policymanagement.dbo.TAdvisePaymentTypeAudit(AdvisePaymentTypeId, TenantId, IsArchived, ConcurrencyId, [Name], IsSystemDefined, GroupId, RefAdvisePaidById, PaymentProviderId
			, StampAction, StampDateTime, StampUser)
		from Policymanagement.dbo.TAdvisePaymentType a
			inner join Policymanagement.dbo.TAdvisePaymentType b on b.[Name] = a.[Name] and b.TenantId = @SourceIndigoClientId
		where a.TenantId = @IndigoClientId
			and a.RefAdvisePaidById != b.RefAdvisePaidById

		delete a
		output
			deleted.AdvisePaymentTypeId, deleted.TenantId, deleted.IsArchived, deleted.ConcurrencyId, deleted.[Name], deleted.IsSystemDefined, deleted.GroupId, deleted.RefAdvisePaidById, deleted.PaymentProviderId
			,'D', @Now, @StampUser
		into Policymanagement.dbo.TAdvisePaymentTypeAudit(AdvisePaymentTypeId, TenantId, IsArchived, ConcurrencyId, [Name], IsSystemDefined, GroupId, RefAdvisePaidById, PaymentProviderId
			, StampAction, StampDateTime, StampUser)
		from Policymanagement.dbo.TAdvisePaymentType a
			left join Policymanagement.dbo.TAdvisePaymentType b on b.[Name] = a.[Name] and b.RefAdvisePaidById = a.RefAdvisePaidById and b.TenantId = @SourceIndigoClientId
		where a.TenantId = @IndigoClientId
			and b.AdvisePaymentTypeId is null
			and a.GroupId is null
			and b.GroupId is null

		update a
		set a.IsArchived = b.IsArchived,
			a.ConcurrencyId += 1
		output
			inserted.AdvisePaymentTypeId, inserted.TenantId, inserted.IsArchived, inserted.ConcurrencyId, inserted.[Name], inserted.IsSystemDefined, inserted.GroupId, inserted.RefAdvisePaidById, inserted.PaymentProviderId
			,'U', @Now, @StampUser
		into Policymanagement.dbo.TAdvisePaymentTypeAudit(AdvisePaymentTypeId, TenantId, IsArchived, ConcurrencyId, [Name], IsSystemDefined, GroupId, RefAdvisePaidById, PaymentProviderId
			, StampAction, StampDateTime, StampUser)
		from Policymanagement.dbo.TAdvisePaymentType a
		inner join Policymanagement.dbo.TAdvisePaymentType b on b.[Name] = a.[Name] and b.RefAdvisePaidById = a.RefAdvisePaidById and b.IsSystemDefined = a.IsSystemDefined and b.TenantId = @SourceIndigoClientId
		where a.TenantId = @IndigoClientId
			and a.GroupId is null
			and b.GroupId is null
			and a.IsArchived != b.IsArchived

		insert into Policymanagement.dbo.TAdvisePaymentType(TenantId, IsArchived, ConcurrencyId, [Name], IsSystemDefined, GroupId, RefAdvisePaidById, PaymentProviderId)
		output
			inserted.AdvisePaymentTypeId, inserted.TenantId, inserted.IsArchived, inserted.ConcurrencyId, inserted.[Name], inserted.IsSystemDefined, inserted.GroupId, inserted.RefAdvisePaidById, inserted.PaymentProviderId
			,'C', @Now, @StampUser
		into Policymanagement.dbo.TAdvisePaymentTypeAudit(AdvisePaymentTypeId, TenantId, IsArchived, ConcurrencyId, [Name], IsSystemDefined, GroupId, RefAdvisePaidById, PaymentProviderId
			, StampAction, StampDateTime, StampUser)
		select @IndigoClientId, IsArchived, 1, [Name], IsSystemDefined, GroupId, RefAdvisePaidById, PaymentProviderId
		from Policymanagement.dbo.TAdvisePaymentType
		where TenantId = @SourceIndigoClientId
			and GroupId is null
		except
		select TenantId, IsArchived, 1, [Name], IsSystemDefined, GroupId, RefAdvisePaidById, PaymentProviderId
		from Policymanagement.dbo.TAdvisePaymentType
		where TenantId = @IndigoClientId
			and GroupId is null


		--Adviser Charging > Fee Charging Type

		--select * from PolicyManagement.dbo.TRefAdviseFeeChargingType

		--select a.*,'@@@',b.*
		--from PolicyManagement.dbo.TAdviseFeeChargingType a
		--left outer join PolicyManagement.dbo.TRefAdviseFeeChargingType b on a.RefAdviseFeeChargingTypeId=b.RefAdviseFeeChargingTypeId
		--where a.TenantId in (99,466)
		--order by b.[Name], a.TenantId

		-- >> nothing to update, probably no inserts either

		insert into PolicyManagement.dbo.TAdviseFeeChargingType(RefAdviseFeeChargingTypeId, TenantId, IsArchived, ConcurrencyId, GroupId)
		output
			inserted.AdviseFeeChargingTypeId, inserted.RefAdviseFeeChargingTypeId, inserted.TenantId, inserted.IsArchived, inserted.ConcurrencyId, inserted.GroupId
			,'C', @Now, @StampUser
		into
			PolicyManagement.dbo.TAdviseFeeChargingTypeAudit(AdviseFeeChargingTypeId, RefAdviseFeeChargingTypeId, TenantId, IsArchived, ConcurrencyId, GroupId
			, StampAction, StampDateTime, StampUser)
		select RefAdviseFeeChargingTypeId, @IndigoClientId, IsArchived, 1, GroupId
		from PolicyManagement.dbo.TAdviseFeeChargingType
		where TenantId = @SourceIndigoClientId
			and GroupId is null
		except
		select RefAdviseFeeChargingTypeId, TenantId, IsArchived, 1, GroupId
		from PolicyManagement.dbo.TAdviseFeeChargingType
		where TenantId = @IndigoClientId
			and GroupId is null


		--Adviser Charging > Fee Charging Details

		-- No updates! Affects TFeeModelTemplate

		insert into policymanagement.dbo.TAdviseFeeChargingDetails(
			AdviseFeeChargingTypeId,
			Amount,
			TenantId,
			ConcurrencyId,
			IsArchived,
			PercentageOfFee,
			MinimumFee,
			MaximumFee,
			GroupId,
			MinimumFeePercentage,
			MaximumFeePercentage,
			IsSystemDefined)
		output
			inserted.AdviseFeeChargingDetailsId,
			inserted.AdviseFeeChargingTypeId,
			inserted.Amount,
			inserted.TenantId,
			inserted.ConcurrencyId,
			inserted.IsArchived,
			inserted.PercentageOfFee,
			inserted.MinimumFee,
			inserted.MaximumFee,
			inserted.GroupId,
			inserted.MinimumFeePercentage,
			inserted.MaximumFeePercentage,
			inserted.IsSystemDefined
			,'C', @Now, @StampUser
		into
			policymanagement.dbo.TAdviseFeeChargingDetailsAudit(
			AdviseFeeChargingDetailsId,
			AdviseFeeChargingTypeId,
			Amount,
			TenantId,
			ConcurrencyId,
			IsArchived,
			PercentageOfFee,
			MinimumFee,
			MaximumFee,
			GroupId,
			MinimumFeePercentage,
			MaximumFeePercentage,
			IsSystemDefined
			, StampAction, StampDateTime, StampUser)
		select c.AdviseFeeChargingTypeId,
			Amount,
			@IndigoClientId,
			1,
			a.IsArchived,
			PercentageOfFee,
			MinimumFee,
			MaximumFee,
			a.GroupId,
			MinimumFeePercentage,
			MaximumFeePercentage,
			IsSystemDefined
		from policymanagement.dbo.TAdviseFeeChargingDetails a
			inner join PolicyManagement.dbo.TAdviseFeeChargingType b on a.AdviseFeeChargingTypeId = b.AdviseFeeChargingTypeId
			inner join PolicyManagement.dbo.TAdviseFeeChargingType c on c.RefAdviseFeeChargingTypeId = b.RefAdviseFeeChargingTypeId and c.TenantId = @IndigoClientId
		where a.TenantId = @SourceIndigoClientId
			and a.GroupId is null
			and b.TenantId = @SourceIndigoClientId
		except
		select a.AdviseFeeChargingTypeId,
			Amount,
			a.TenantId,
			1,
			a.IsArchived,
			PercentageOfFee,
			MinimumFee,
			MaximumFee,
			a.GroupId,
			MinimumFeePercentage,
			MaximumFeePercentage,
			IsSystemDefined
		from policymanagement.dbo.TAdviseFeeChargingDetails a
			inner join PolicyManagement.dbo.TAdviseFeeChargingType b on a.AdviseFeeChargingTypeId = b.AdviseFeeChargingTypeId
		where a.TenantId = @IndigoClientId
			and a.GroupId is null
			and b.TenantId = @IndigoClientId


		--Adviser Charging > Discounts
		--select * from PolicyManagement.dbo.TDiscount a where a.TenantId = 99 and GroupId is null ORDER BY a.[Name]

		update a
		set a.Amount = b.Amount,
			a.[Percentage] = b.[Percentage],
			a.Reason = b.Reason,
			a.IsArchived = b.IsArchived,
			a.IsRange = b.IsRange,
			a.MinAmount = b.MinAmount,
			a.MaxAmount = b.MaxAmount,
			a.MinPercentage = b.MinPercentage,
			a.MaxPercentage = b.MaxPercentage,
			a.ConcurrencyId +=1
		output
			inserted.DiscountId,
			inserted.[Name],
			inserted.Amount,
			inserted.[Percentage],
			inserted.Reason,
			inserted.IsArchived,
			inserted.TenantId,
			inserted.ConcurrencyId,
			inserted.GroupId,
			-- not in Audit table
			--inserted.IsRange,
			--inserted.MinAmount,
			--inserted.MaxAmount,
			--inserted.MinPercentage,
			--inserted.MaxPercentage,
			'U', @Now, @StampUser
		into PolicyManagement.dbo.TDiscountAudit(
			DiscountId,
			[Name],
			Amount,
			[Percentage],
			Reason,
			IsArchived,
			TenantId,
			ConcurrencyId,
			GroupId,
			-- not in Audit table
			--IsRange,
			--MinAmount,
			--MaxAmount,
			--MinPercentage,
			--MaxPercentage,
			StampAction, StampDateTime, StampUser)
		from PolicyManagement.dbo.TDiscount a
			inner join PolicyManagement.dbo.TDiscount b on b.[Name] = a.[Name] and b.TenantId = @SourceIndigoClientId
		where a.TenantId = @IndigoClientId
			and a.GroupId is null
			and b.GroupId is null
			and (a.IsArchived != b.IsArchived
				or a.IsRange != b.IsRange
				or isnull(a.Amount,0.00) != isnull(b.Amount,0.00)
				or isnull(a.[Percentage],0.00) != isnull(b.[Percentage],0.00)
				or isnull(a.Reason,'') != isnull(b.Reason,'')
				or isnull(a.MinAmount,0.00) != isnull(b.MinAmount,0.00)
				or isnull(a.MaxAmount,0.00) != isnull(b.MaxAmount,0.00)
				or isnull(a.MinPercentage,0.00) != isnull(b.MinPercentage,0.00)
				or isnull(a.MaxPercentage,0.00) != isnull(b.MaxPercentage,0.00)
			)

		insert into PolicyManagement.dbo.TDiscount(
			[Name],
			Amount,
			[Percentage],
			Reason,
			IsArchived,
			TenantId,
			ConcurrencyId,
			GroupId,
			IsRange,
			MinAmount,
			MaxAmount,
			MinPercentage,
			MaxPercentage)
		output
			inserted.DiscountId,
			inserted.[Name],
			inserted.Amount,
			inserted.[Percentage],
			inserted.Reason,
			inserted.IsArchived,
			inserted.TenantId,
			inserted.ConcurrencyId,
			inserted.GroupId,
			-- not in Audit table
			--inserted.IsRange,
			--inserted.MinAmount,
			--inserted.MaxAmount,
			--inserted.MinPercentage,
			--inserted.MaxPercentage
			'C', @Now, @StampUser
		into PolicyManagement.dbo.TDiscountAudit(
			DiscountId,
			[Name],
			Amount,
			[Percentage],
			Reason,
			IsArchived,
			TenantId,
			ConcurrencyId,
			GroupId,
			-- not in Audit table
			--IsRange,
			--MinAmount,
			--MaxAmount,
			--MinPercentage,
			--MaxPercentage
			StampAction, StampDateTime, StampUser)

		select [Name],
			Amount,
			[Percentage],
			Reason,
			IsArchived,
			@IndigoClientId,
			1,
			GroupId,
			IsRange,
			MinAmount,
			MaxAmount,
			MinPercentage,
			MaxPercentage
		from PolicyManagement.dbo.TDiscount
		where TenantId = @SourceIndigoClientId
			and GroupId is null
		except
		select [Name],
			Amount,
			[Percentage],
			Reason,
			IsArchived,
			TenantId,
			1,
			GroupId,
			IsRange,
			MinAmount,
			MaxAmount,
			MinPercentage,
			MaxPercentage
		from PolicyManagement.dbo.TDiscount
		where TenantId = @IndigoClientId
			and GroupId is null


		--Adviser Charging > Discounts >> ROLES
		--select a.*
		--from PolicyManagement.dbo.TDiscountToRole a
		--inner join PolicyManagement.dbo.TDiscount ds on ds.DiscountId = a.DiscountId and ds.TenantId = a.TenantId
		--inner join Administration.dbo.TRole rs on rs.RoleId = a.RoleId and rs.IndigoClientId = a.TenantId
		--where a.TenantId = 90


		insert into PolicyManagement.dbo.TDiscountToRole(DiscountId, RoleId, TenantId, ConcurrencyId)
		output
			inserted.DiscountToRoleId, inserted.DiscountId, inserted.RoleId, inserted.TenantId, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into
			PolicyManagement.dbo.TDiscountToRoleAudit(DiscountToRoleId, DiscountId, RoleId, TenantId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)

		select dt.DiscountId, rt.RoleId, @IndigoClientId, 1
		from PolicyManagement.dbo.TDiscountToRole a
			inner join Administration.dbo.TRole rs on rs.RoleId = a.RoleId and rs.IndigoClientId = @SourceIndigoClientId
			inner join Administration.dbo.TRole rt on rt.Identifier = rs.Identifier and rt.IndigoClientId = @IndigoClientId
			inner join PolicyManagement.dbo.TDiscount ds on ds.DiscountId = a.DiscountId and ds.TenantId = @SourceIndigoClientId
			inner join PolicyManagement.dbo.TDiscount dt on dt.[Name] = ds.[Name] and dt.TenantId = @IndigoClientId
		where a.TenantId = @SourceIndigoClientId
			and ds.GroupId is null
			and dt.GroupId is null
			and ds.IsArchived = dt.IsArchived
			and ds.IsRange = dt.IsRange
			and isnull(ds.Amount,0.00) = isnull(dt.Amount,0.00)
			and isnull(ds.[Percentage],0.00) = isnull(dt.[Percentage],0.00)
			and isnull(ds.Reason,'') = isnull(dt.Reason,'')
			and isnull(ds.MinAmount,0.00) = isnull(dt.MinAmount,0.00)
			and isnull(ds.MaxAmount,0.00) = isnull(dt.MaxAmount,0.00)
			and isnull(ds.MinPercentage,0.00) = isnull(dt.MinPercentage,0.00)
			and isnull(ds.MaxPercentage,0.00) = isnull(dt.MaxPercentage,0.00)
		except
		select a.DiscountId, RoleId, a.TenantId, 1
		from PolicyManagement.dbo.TDiscountToRole a
			inner join PolicyManagement.dbo.TDiscount b on b.DiscountId = a.DiscountId and b.TenantId = @IndigoClientId
		where a.TenantId = @IndigoClientId
			and b.GroupId is null


		delete a
		output
			deleted.AdviseCategoryToFeeModelId, deleted.AdviseCategoryId, deleted.FeeModelId, deleted.ConcurrencyId
			,'D', @Now, @StampUser
		into CRM.dbo.TAdviseCategoryToFeeModelAudit(AdviseCategoryToFeeModelId, AdviseCategoryId, FeeModelId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from CRM.dbo.TAdviseCategoryToFeeModel a
			inner join PolicyManagement.dbo.TAdviseCategory b on b.AdviseCategoryId = a.AdviseCategoryId and b.TenantId = @IndigoClientId
			inner join PolicyManagement.dbo.TFeeModel c on c.FeeModelId = a.FeeModelId and c.TenantId = @IndigoClientId
		where not exists(select 1 from CRM.dbo.TAdviseCategoryToFeeModel a2
			inner join PolicyManagement.dbo.TAdviseCategory b2 on b2.AdviseCategoryId = a2.AdviseCategoryId and b2.TenantId = @SourceIndigoClientId
			inner join PolicyManagement.dbo.TFeeModel c2 on c2.FeeModelId = a2.FeeModelId and c2.TenantId = @SourceIndigoClientId
			where b2.[Name] = b.[Name]
			and c2.[Name] = c.[Name])

		insert into CRM.dbo.TAdviseCategoryToFeeModel(AdviseCategoryId, FeeModelId, ConcurrencyId)
		output
			inserted.AdviseCategoryToFeeModelId, inserted.AdviseCategoryId, inserted.FeeModelId, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into CRM.dbo.TAdviseCategoryToFeeModelAudit(AdviseCategoryToFeeModelId, AdviseCategoryId, FeeModelId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)

		select actrgt.AdviseCategoryId, fmtrgt.FeeModelId, 1
		from crm.dbo.TAdviseCategoryToFeeModel a
		inner join PolicyManagement.dbo.TAdviseCategory acsrc on acsrc.AdviseCategoryId = a.AdviseCategoryId and acsrc.TenantId = @SourceIndigoClientId
		inner join PolicyManagement.dbo.TFeeModel fmsrc on fmsrc.FeeModelId = a.FeeModelId and fmsrc.TenantId = @SourceIndigoClientId
		inner join PolicyManagement.dbo.TAdviseCategory actrgt on actrgt.[Name] = acsrc.[Name] and actrgt.TenantId = @IndigoClientId
		inner join PolicyManagement.dbo.TFeeModel fmtrgt on fmtrgt.[Name] = fmsrc.[Name] and fmtrgt.TenantId = @IndigoClientId
		where acsrc.GroupId is null and fmsrc.GroupId is null
			and actrgt.GroupId is null and fmtrgt.GroupId is null
		except
		select a.AdviseCategoryId, a.FeeModelId, 1
		from crm.dbo.TAdviseCategoryToFeeModel a
		inner join PolicyManagement.dbo.TAdviseCategory b on b.AdviseCategoryId = a.AdviseCategoryId and b.TenantId = @IndigoClientId
		inner join PolicyManagement.dbo.TFeeModel c on c.FeeModelId = a.FeeModelId and c.TenantId = @IndigoClientId


		-- Organisation > Adviser Charging > Fee Model >> OPEN
		---***************************************************************************
		-- This block handles TFeeModelTemplate and TFeeModelTemplateToPlanType
		-- START START START START START START START START
		---***************************************************************************

		delete a
		from PolicyManagement.dbo.TFeeModelTemplateToPlanType a
		where TenantId = @IndigoClientId

		drop table if exists #InsertOutput
		create table #InsertOutput (IO_MIgrationRef varchar(max), TheNewId int NOT NULL)

		drop table if exists #FeeModelTemplate

		select
			'iO2iO:'+convert(varchar(10), a.FeeModelTemplateId) as IO_MigrationRef,
			a.FeeModelTemplateId,
			fmsrc.FeeModelId,
			fmtrgt.FeeModelId as IO_ID_FK_FeeModelId,
			aftsrc.AdviseFeeTypeId,
			afttrgt.AdviseFeeTypeId as IO_ID_FK_AdviseFeeTypeId,
			afcd.AdviseFeeChargingDetailsId,
			afcdtrgt.AdviseFeeChargingDetailsId as IO_ID_FK_AdviseFeeChargingDetailsId,
			FeeAmount,
			a.IsDefault,
			VATAmount,
			IsVATExcempt,
			@SourceIndigoClientId as IndigoClientId,
			@IndigoClientId as IO_ID_FK_IndigoClientId,
			1 as ConcurrencyId,
			RecurringFrequencyId,
			InstalmentsFrequencyId,
			RefVATId,
			InitialPeriod,
			IsInstalments,
			IsPaidByProvider,
			NumRecurringPayments,
			RefAdviceContributionTypeId,
			a.StartDate,
			a.EndDate,
			RefFeeAdviseTypeId,
			FeePercentage,
			IsConsultancyFee,
			ServiceStatusId,
			convert(int, NULL) as IO_ID_FeeModelTemplateId
		into #FeeModelTemplate
		from PolicyManagement.dbo.TFeeModelTemplate a
			inner join PolicyManagement.dbo.TFeeModel fmsrc on fmsrc.FeeModelId = a.FeeModelId and fmsrc.TenantId = @SourceIndigoClientId
			inner join PolicyManagement.dbo.TAdviseFeeType aftsrc on aftsrc.AdviseFeeTypeId = a.AdviseFeeTypeId and aftsrc.TenantId = @SourceIndigoClientId
			inner join policymanagement.dbo.TAdviseFeeChargingDetails afcd on a.AdviseFeeChargingDetailsId=afcd.AdviseFeeChargingDetailsId
			inner join policymanagement.dbo.TAdviseFeeChargingType afct on afct.AdviseFeeChargingTypeId = afcd.AdviseFeeChargingTypeId and afct.TenantId = @SourceIndigoClientId

			inner join policymanagement.dbo.TAdviseFeeChargingType afcttrgt on afcttrgt.RefAdviseFeeChargingTypeId = afct.RefAdviseFeeChargingTypeId and afcttrgt.TenantId = @IndigoClientId
			inner join policymanagement.dbo.TAdviseFeeChargingDetails afcdtrgt on afcdtrgt.AdviseFeeChargingTypeId = afcttrgt.AdviseFeeChargingTypeId and afcdtrgt.TenantId = @IndigoClientId
			inner join PolicyManagement.dbo.TAdviseFeeType afttrgt on afttrgt.[Name] = aftsrc.[Name] and afttrgt.RefAdviseFeeTypeId = aftsrc.RefAdviseFeeTypeId and afttrgt.IsSystemDefined = aftsrc.IsSystemDefined and afttrgt.TenantId = @IndigoClientId
			inner join PolicyManagement.dbo.TFeeModel fmtrgt on fmtrgt.[Name] = fmsrc.[Name] and fmtrgt.RefFeeModelStatusId = fmsrc.RefFeeModelStatusId and fmtrgt.IsSystemDefined = fmsrc.IsSystemDefined and fmtrgt.TenantId = @IndigoClientId
		where isnull(afcdtrgt.PercentageOfFee,0.0)=isnull(afcd.PercentageOfFee,0.0)
			and isnull(afcdtrgt.MinimumFee,0.0)=isnull(afcd.MinimumFee,0.0)
			and isnull(afcdtrgt.MaximumFee,0.0)=isnull(afcd.MaximumFee,0.0)


		alter table #FeeModelTemplate add IO_ID_Status varchar(100)

		delete a
		from #FeeModelTemplate a
		where exists(
		select 1
		from PolicyManagement.dbo.TFeeModelTemplate b
		where TenantId = @IndigoClientId
			and b.FeeModelId = a.IO_ID_FK_FeeModelId
			and b.AdviseFeeTypeId = a.IO_ID_FK_AdviseFeeTypeId
			and b.AdviseFeeChargingDetailsId = a.IO_ID_FK_AdviseFeeChargingDetailsId
			and b.FeeAmount = a.FeeAmount
			and b.IsDefault = a.IsDefault
			and b.VATAmount = a.VATAmount
			and b.IsVATExcempt = a.IsVATExcempt
			and isnull(b.RecurringFrequencyId,0) = isnull(a.RecurringFrequencyId,0)
			and isnull(b.InstalmentsFrequencyId,0) = isnull(a.InstalmentsFrequencyId,0)
			and isnull(b.RefVATId,0) = isnull(a.RefVATId,0)
			and isnull(b.InitialPeriod,0) = isnull(a.InitialPeriod,0)
			and b.IsInstalments = a.IsInstalments
			and b.IsPaidByProvider = a.IsPaidByProvider
			and isnull(b.NumRecurringPayments,0) = isnull(a.NumRecurringPayments,0)
			and isnull(b.RefAdviceContributionTypeId,0) = isnull(a.RefAdviceContributionTypeId,0)
			and isnull(b.StartDate,@Now) = isnull(a.StartDate,@Now)
			and isnull(b.EndDate,@Now) = isnull(a.EndDate,@Now)
			and b.RefFeeAdviseTypeId = a.RefFeeAdviseTypeId
			and b.FeePercentage = a.FeePercentage
			and b.IsConsultancyFee = a.IsConsultancyFee
			and isnull(b.ServiceStatusId,0) = isnull(a.ServiceStatusId,0))



			truncate table #InsertOutput
			Set @IO_MigrationRef = ''

			while (1=1) begin
				Select top 1 @IO_MigrationRef = IO_MigrationRef,
					@FeeModelTemplateId = FeeModelTemplateId
				from #FeeModelTemplate
				where IO_MigrationRef > @IO_MigrationRef
					and IO_ID_Status is null
				order by IO_MigrationRef

				if (@@ROWCOUNT=0) break

				insert into PolicyManagement.dbo.TFeeModelTemplate(
					FeeModelId,
					AdviseFeeTypeId,
					AdviseFeeChargingDetailsId,
					FeeAmount,
					IsDefault,
					VATAmount,
					IsVATExcempt,
					TenantId,
					ConcurrencyId,
					RecurringFrequencyId,
					InstalmentsFrequencyId,
					RefVATId,
					InitialPeriod,
					IsInstalments,
					IsPaidByProvider,
					NumRecurringPayments,
					RefAdviceContributionTypeId,
					StartDate,
					EndDate,
					RefFeeAdviseTypeId,
					FeePercentage,
					IsConsultancyFee,
					ServiceStatusId)
				output @IO_MigrationRef, inserted.FeeModelTemplateId
				into #InsertOutput(IO_MIgrationRef, TheNewId)
				select IO_ID_FK_FeeModelId,
					IO_ID_FK_AdviseFeeTypeId,
					IO_ID_FK_AdviseFeeChargingDetailsId,
					FeeAmount,
					IsDefault,
					VATAmount,
					IsVATExcempt,
					IO_ID_FK_IndigoClientId,
					ConcurrencyId,
					RecurringFrequencyId,
					InstalmentsFrequencyId,
					RefVATId,
					InitialPeriod,
					IsInstalments,
					IsPaidByProvider,
					NumRecurringPayments,
					RefAdviceContributionTypeId,
					StartDate,
					EndDate,
					RefFeeAdviseTypeId,
					FeePercentage,
					IsConsultancyFee,
					ServiceStatusId
				from #FeeModelTemplate
				where IO_MigrationRef = @IO_MigrationRef

			end

			update a
			set IO_ID_FeeModelTemplateId = b.TheNewId,
				IO_ID_Status = 'NEW'
			from #FeeModelTemplate a
				inner join #InsertOutput b on b.IO_MigrationRef = a.IO_MigrationRef

			insert into PolicyManagement.dbo.TFeeModelTemplateToPlanType(FeeModelTemplateId, RefPlanTypeId, TenantId, ConcurrencyId)
			output
				inserted.FeeModelTemplateToPlanTypeId, inserted.FeeModelTemplateId, inserted.RefPlanTypeId, inserted.TenantId, inserted.ConcurrencyId
				,'C', @Now, @StampUser
			into PolicyManagement.dbo.TFeeModelTemplateToPlanTypeAudit(
				FeeModelTemplateToPlanTypeId, FeeModelTemplateId, RefPlanTypeId, TenantId, ConcurrencyId
				, StampAction, StampDateTime, StampUser)
			Select a.IO_ID_FeeModelTemplateId, RefPlanTypeId, a.IO_ID_FK_IndigoClientId, 1
			from #FeeModelTemplate a
				inner join PolicyManagement.dbo.TFeeModelTemplateToPlanType b on b.FeeModelTemplateId = a.FeeModelTemplateId

			insert into PolicyManagement.dbo.TFeeModelTemplateAudit(
					FeeModelTemplateId,
					FeeModelId,
					AdviseFeeTypeId,
					AdviseFeeChargingDetailsId,
					FeeAmount,
					IsDefault,
					VATAmount,
					IsVATExcempt,
					TenantId,
					ConcurrencyId,
					RecurringFrequencyId,
					InstalmentsFrequencyId,
					RefVATId,
					InitialPeriod,
					IsInstalments,
					IsPaidByProvider,
					NumRecurringPayments,
					RefAdviceContributionTypeId,
					StartDate,
					EndDate,
					RefFeeAdviseTypeId,
					FeePercentage,
					IsConsultancyFee,
					ServiceStatusId
					, StampAction, StampDateTime, StampUser)
				select
					a.FeeModelTemplateId,
					a.FeeModelId,
					a.AdviseFeeTypeId,
					a.AdviseFeeChargingDetailsId,
					a.FeeAmount,
					a.IsDefault,
					a.VATAmount,
					a.IsVATExcempt,
					a.TenantId,
					a.ConcurrencyId,
					a.RecurringFrequencyId,
					a.InstalmentsFrequencyId,
					a.RefVATId,
					a.InitialPeriod,
					a.IsInstalments,
					a.IsPaidByProvider,
					a.NumRecurringPayments,
					a.RefAdviceContributionTypeId,
					a.StartDate,
					a.EndDate,
					a.RefFeeAdviseTypeId,
					a.FeePercentage,
					a.IsConsultancyFee,
					a.ServiceStatusId
					,'C', @Now, @StampUser
				from PolicyManagement.dbo.TFeeModelTemplate a
				inner join #FeeModelTemplate b on b.IO_ID_FeeModelTemplateId = a.FeeModelTemplateId
					inner join #InsertOutput c on c.TheNewId = b.IO_ID_FeeModelTemplateId -- redundant, but for safety reasons
				where b.IO_ID_Status = 'NEW'
				and a.TenantId = @IndigoClientId


		drop table if exists #InsertOutput

		drop table if exists #FeeModelTemplate



		---***************************************************************************
		-- This block handles TFeeModelTemplate and TFeeModelTemplateToPlanType
		-- END END END END END END END END END END END END
		---***************************************************************************

		-- TFeeModelTemplateToDiscount

		insert into PolicyManagement.dbo.TFeeModelTemplateToDiscount(FeeModelTemplateId, DiscountId, TenantId, ConcurrencyId)
		output
			inserted.FeeModelTemplateToDiscountId, inserted.FeeModelTemplateId, inserted.DiscountId, inserted.TenantId, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into
			PolicyManagement.dbo.TFeeModelTemplateToDiscountAudit(FeeModelTemplateToDiscountId, FeeModelTemplateId, DiscountId, TenantId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)

		select fmtt.FeeModelTemplateId, dt.DiscountId, @IndigoClientId, 1
		from PolicyManagement.dbo.TFeeModelTemplateToDiscount fmtds
		inner join PolicyManagement.dbo.TFeeModelTemplate fmts on fmts.FeeModelTemplateId = fmtds.FeeModelTemplateId and fmts.TenantId = @SourceIndigoClientId
		inner join PolicyManagement.dbo.TAdviseFeeChargingDetails afcds on afcds.AdviseFeeChargingDetailsId = fmts.AdviseFeeChargingDetailsId and afcds.TenantId = @SourceIndigoClientId
		inner join PolicyManagement.dbo.TAdviseFeeChargingType afcts on afcts.AdviseFeeChargingTypeId = afcds.AdviseFeeChargingTypeId and afcts.TenantId = @SourceIndigoClientId
		-- Discount
		inner join PolicyManagement.dbo.TDiscount ds on ds.DiscountId = fmtds.DiscountId and ds.TenantId = @SourceIndigoClientId
		-- PolicyManagement.dbo.TRefAdviseFeeChargingType

		inner join PolicyManagement.dbo.TAdviseFeeChargingType afctt on afctt.RefAdviseFeeChargingTypeId = afcts.RefAdviseFeeChargingTypeId and afctt.TenantId = @IndigoClientId
		inner join PolicyManagement.dbo.TAdviseFeeChargingDetails afcdt on afcdt.AdviseFeeChargingTypeId = afctt.AdviseFeeChargingTypeId and afcdt.TenantId = @IndigoClientId
		inner join PolicyManagement.dbo.TFeeModelTemplate fmtt on fmtt.AdviseFeeChargingDetailsId = afcdt.AdviseFeeChargingDetailsId and fmtt.TenantId = @IndigoClientId
		inner join PolicyManagement.dbo.TDiscount dt on dt.[Name] = ds.[Name] and dt.TenantId = @IndigoClientId
		where fmtds.TenantId = @SourceIndigoClientId
			-- TDiscount
			and ds.GroupId is null
			and dt.GroupId is null
			and ds.IsArchived = dt.IsArchived
			and ds.IsRange = dt.IsRange
			and isnull(ds.Amount,0.00) = isnull(dt.Amount,0.00)
			and isnull(ds.[Percentage],0.00) = isnull(dt.[Percentage],0.00)
			and isnull(ds.Reason,'') = isnull(dt.Reason,'')
			and isnull(ds.MinAmount,0.00) = isnull(dt.MinAmount,0.00)
			and isnull(ds.MaxAmount,0.00) = isnull(dt.MaxAmount,0.00)
			and isnull(ds.MinPercentage,0.00) = isnull(dt.MinPercentage,0.00)
			and isnull(ds.MaxPercentage,0.00) = isnull(dt.MaxPercentage,0.00)
			-- TAdviseFeeChargingDetails
			and afcds.GroupId is null
			and afcts.GroupId is null
			and afcds.IsSystemDefined = afcdt.IsSystemDefined
			and afcds.IsArchived = afcdt.IsArchived
			and isnull(afcds.Amount,0.00) = isnull(afcdt.Amount,0.00)
			and isnull(afcds.IsArchived,0) = isnull(afcdt.IsArchived,0)
			and isnull(afcds.PercentageOfFee,0.00) = isnull(afcdt.PercentageOfFee,0.00)
			and isnull(afcds.MinimumFee,0.00) = isnull(afcdt.MinimumFee,0.00)
			and isnull(afcds.MaximumFee,0.00) = isnull(afcdt.MaximumFee,0.00)
			and isnull(afcds.MinimumFeePercentage,0.00) = isnull(afcdt.MinimumFeePercentage,0.00)
			and isnull(afcds.MaximumFeePercentage,0.00) = isnull(afcdt.MaximumFeePercentage,0.00)

		except
		select FeeModelTemplateId, DiscountId, TenantId, 1
		from PolicyManagement.dbo.TFeeModelTemplateToDiscount a
		where a.TenantId = @IndigoClientId




		-- TFeeModelTemplateToAdvisePaymentType
		-- DM-3296 : START
		delete PolicyManagement.dbo.TFeeModelTemplateToAdvisePaymentType
		output
			deleted.FeeModelTemplateToAdvisePaymentTypeId, deleted.FeeModelTemplateId, deleted.AdvisePaymentTypeId, deleted.TenantId, deleted.ConcurrencyId
			,'D', @Now, @StampUser
		into PolicyManagement.dbo.TFeeModelTemplateToAdvisePaymentTypeAudit(FeeModelTemplateToAdvisePaymentTypeId, FeeModelTemplateId, AdvisePaymentTypeId, TenantId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		where TenantId = @IndigoClientId

		drop table if exists #FeeModelTemplateToAdvisePaymentType

		select *, New_FeeModelTemplateId=convert(int, NULL), New_AdvisePaymentTypeId=convert(int, NULL)
		into #FeeModelTemplateToAdvisePaymentType
		from PolicyManagement.dbo.TFeeModelTemplateToAdvisePaymentType
		where TenantId = @SourceIndigoClientId

		update a
		set New_FeeModelTemplateId = fmtt.FeeModelTemplateId
		from #FeeModelTemplateToAdvisePaymentType a
		inner join policymanagement.dbo.TFeeModelTemplate fmts on fmts.FeeModelTemplateId = a.FeeModelTemplateId and fmts.TenantId = @SourceIndigoClientId
		inner join policymanagement.dbo.TFeeModel fms on fms.FeeModelId = fmts.FeeModelId and fms.TenantId = @SourceIndigoClientId
		inner join policymanagement.dbo.TAdviseFeeType afts on afts.AdviseFeeTypeId = fmts.AdviseFeeTypeId and afts.TenantId = @SourceIndigoClientId

		inner join policymanagement.dbo.TFeeModel fmt on fmt.RefFeeModelStatusId = fms.RefFeeModelStatusId and fmt.[Name] = fms.[Name] and fmt.TenantId = @IndigoClientId
		inner join policymanagement.dbo.TAdviseFeeType aftt on aftt.[Name] = afts.[Name] and aftt.RefAdviseFeeTypeId = afts.RefAdviseFeeTypeId and aftt.TenantId = @IndigoClientId 
		inner join policymanagement.dbo.TFeeModelTemplate fmtt on aftt.AdviseFeeTypeId = fmtt.AdviseFeeTypeId and fmtt.FeeModelId = fmt.FeeModelId and fmtt.TenantId = @IndigoClientId
		where fmt.IsPropagated = fms.IsPropagated
		and fmt.IsSystemDefined = fms.IsSystemDefined
		and fmt.IsDefault = fms.IsDefault
		and fmt.IsArchived = fms.IsArchived
		and isnull(fmt.StartDate,@Now) = isnull(fms.StartDate,@Now)

		and aftt.IsArchived = afts.IsArchived
		and aftt.IsRecurring = afts.IsRecurring
		and aftt.IsSystemDefined = afts.IsSystemDefined

		and fmtt.FeeAmount = fmts.FeeAmount
		and fmtt.IsDefault = fmts.IsDefault
		and fmtt.VATAmount = fmts.VATAmount
		and fmtt.IsVATExcempt = fmts.IsVATExcempt
		and isnull(fmtt.RecurringFrequencyId,-1) = isnull(fmts.RecurringFrequencyId,-1)
		and isnull(fmtt.FeePercentage,-1.00) = isnull(fmts.FeePercentage,-1.00)

		update a
		set New_AdvisePaymentTypeId = aptt.AdvisePaymentTypeId
		from #FeeModelTemplateToAdvisePaymentType a
		inner join policymanagement.dbo.TAdvisePaymentType apts on apts.AdvisePaymentTypeId = a.AdvisePaymentTypeId and apts.TenantId = @SourceIndigoClientId
		inner join policymanagement.dbo.TAdvisePaymentType aptt on aptt.RefAdvisePaidById = apts.RefAdvisePaidById and aptt.TenantId = @IndigoClientId

		insert into PolicyManagement.dbo.TFeeModelTemplateToAdvisePaymentType(FeeModelTemplateId, AdvisePaymentTypeId, TenantId, ConcurrencyId)
		output
			inserted.FeeModelTemplateToAdvisePaymentTypeId, inserted.FeeModelTemplateId, inserted.AdvisePaymentTypeId, inserted.TenantId, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into PolicyManagement.dbo.TFeeModelTemplateToAdvisePaymentTypeAudit(FeeModelTemplateToAdvisePaymentTypeId, FeeModelTemplateId, AdvisePaymentTypeId, TenantId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select New_FeeModelTemplateId, New_AdvisePaymentTypeId, @IndigoClientId, 1
		from #FeeModelTemplateToAdvisePaymentType
		except
		select FeeModelTemplateId, AdvisePaymentTypeId, TenantId, 1
		from PolicyManagement.dbo.TFeeModelTemplateToAdvisePaymentType
		where TenantId = @IndigoClientId

		drop table if exists #FeeModelTemplateToAdvisePaymentType

		-- DM-3296 : END

		if @tx = 0 begin
			commit transaction TX
			set @msg=@ProcName+': commit transaction TX'
			raiserror(@msg,0,1) with nowait
		end

		drop table if exists #FeeModelTemplateToAdvisePaymentType

		exec dbo.spStopCreateTenantModule @IndigoClientId, @SourceIndigoClientId, @ProcName

	end try
	begin catch
		declare @Errmsg varchar(max) = @ProcName+'
'+ERROR_MESSAGE()

		if @tx = 0 begin
			set @msg=@ProcName+': rollback transaction TX'
			raiserror(@msg,0,1) with nowait
			rollback transaction TX
		end
		raiserror(@Errmsg,16,1)
	end catch

end
GO
