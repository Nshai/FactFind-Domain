SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCloneServiceCase] @IndigoClientId int, @SourceIndigoClientId int, @StampUser varchar(255) = '-1010'
as
begin
-- Compliance > Administration > File Checking > Service Case Statuses

-- Service cases categories, statuses, transitions, auto-close and automated fee model creation setting
-- Administration > Organisation > Adviser Charging > Service Case Category
	set nocount on
	declare @ProcName sysname = OBJECT_NAME(@@PROCID),
		@procResult int
	exec @procResult = dbo.spStartCreateTenantModule @IndigoClientId, @SourceIndigoClientId, @ProcName
	if @procResult!=0 return

	declare @tx int,
		@Now datetime = GetDate(),
		@msg varchar(max)

	select @tx = @@TRANCOUNT

	if @tx = 0 begin
		set @msg=@ProcName+': begin transaction TX'
		raiserror(@msg,0,1) with nowait
		begin transaction TX
	end

	begin try

		-- Service Case Auto-Close
		-- Compliance > Administration > File Checking > Service Case Statuses

		-- UNIQUE RECORD
		update a
			set a.NumberOfDays = b.NumberOfDays,
				a.AdviceCaseAutoCloseRule = b.AdviceCaseAutoCloseRule,
				a.HasReopenRule = b.HasReopenRule,
				a.ReopenNumberOfDays = b.ReopenNumberOfDays,
				a.ConcurrencyId+=1
		output
			inserted.AdviceCaseAutoCloseStatusRuleId, inserted.IndigoClientId, inserted.NumberOfDays, inserted.AdviceCaseAutoCloseRule, inserted.HasReopenRule, inserted.ReopenNumberOfDays, inserted.ConcurrencyId
			,'U', @Now, @StampUser
		into CRM.dbo.TAdviceCaseAutoCloseStatusRuleAudit(AdviceCaseAutoCloseStatusRuleId, IndigoClientId, NumberOfDays, AdviceCaseAutoCloseRule, HasReopenRule, ReopenNumberOfDays, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from CRM.dbo.TAdviceCaseAutoCloseStatusRule a, CRM.dbo.TAdviceCaseAutoCloseStatusRule b
		where a.IndigoClientId = @IndigoClientId and b.IndigoClientId = @SourceIndigoClientId

		if @@rowcount=0

		insert into CRM.dbo.TAdviceCaseAutoCloseStatusRule(IndigoClientId, NumberOfDays, AdviceCaseAutoCloseRule, HasReopenRule, ReopenNumberOfDays, ConcurrencyId)
		select @IndigoClientId, NumberOfDays, AdviceCaseAutoCloseRule, HasReopenRule, ReopenNumberOfDays, 1
		from CRM.dbo.TAdviceCaseAutoCloseStatusRule
		where IndigoClientId = @SourceIndigoClientId


		-- TAdviceCaseStatus
		update a
		set a.IsDefault = b.IsDefault,
			a.IsComplete = b.IsComplete,
			a.IsAutoClose = b.IsAutoClose,
			a.ConcurrencyId +=1
		output
			inserted.AdviceCaseStatusId, inserted.TenantId, inserted.Descriptor, inserted.IsDefault, inserted.IsComplete, inserted.ConcurrencyId, inserted.IsAutoClose
			,'U', @Now, @StampUser
		into CRM.dbo.TAdviceCaseStatusAudit(AdviceCaseStatusId, TenantId, Descriptor, IsDefault, IsComplete, ConcurrencyId, IsAutoClose
			, StampAction, StampDateTime, StampUser)
		from CRM.dbo.TAdviceCaseStatus a
			inner join CRM.dbo.TAdviceCaseStatus b on b.Descriptor = a.Descriptor and b.TenantId = @SourceIndigoClientId
		where a.TenantId = @IndigoClientId

		insert into CRM.dbo.TAdviceCaseStatus(TenantId, Descriptor, IsDefault, IsComplete, ConcurrencyId, IsAutoClose)
		output
			inserted.AdviceCaseStatusId, inserted.TenantId, inserted.Descriptor, inserted.IsDefault, inserted.IsComplete, inserted.ConcurrencyId, inserted.IsAutoClose
			,'C', @Now, @StampUser
		into CRM.dbo.TAdviceCaseStatusAudit(AdviceCaseStatusId, TenantId, Descriptor, IsDefault, IsComplete, ConcurrencyId, IsAutoClose
			, StampAction, StampDateTime, StampUser)

		select @IndigoClientId, Descriptor, IsDefault, IsComplete, 1, IsAutoClose
		from CRM.dbo.TAdviceCaseStatus
		where TenantId = @SourceIndigoClientId
		except
		select TenantId, Descriptor, IsDefault, IsComplete, 1, IsAutoClose
		from CRM.dbo.TAdviceCaseStatus
		where TenantId = @IndigoClientId


		-- delete missing Rules
		delete a
		output
			deleted.AdviceCaseStatusTransitionRuleId, deleted.AdviceCaseStatusChangeId, deleted.AdviceCaseStatusRuleId, deleted.ConcurrencyId
			,'D', @Now, @StampUser
		into CRM.dbo.TAdviceCaseStatusTransitionRuleAudit(
			AdviceCaseStatusTransitionRuleId, AdviceCaseStatusChangeId, AdviceCaseStatusRuleId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from CRM.dbo.TAdviceCaseStatusTransitionRule a
			inner join CRM.dbo.TAdviceCaseStatusChange b on b.AdviceCaseStatusChangeId = a.AdviceCaseStatusChangeId
			inner join CRM.dbo.TAdviceCaseStatus from1 on from1.AdviceCaseStatusId = b.AdviceCaseStatusIdFrom and from1.TenantId = b.IndigoClientId
			inner join CRM.dbo.TAdviceCaseStatus to1 on to1.AdviceCaseStatusId = b.AdviceCaseStatusIdTo and to1.TenantId = b.IndigoClientId
		where b.IndigoClientId = @IndigoClientId
			and not exists( select 1 from CRM.dbo.TAdviceCaseStatusChange c
			inner join CRM.dbo.TAdviceCaseStatus fromSrc on b.AdviceCaseStatusIdFrom = fromSrc.AdviceCaseStatusId and fromSrc.TenantId = c.IndigoClientId
			inner join CRM.dbo.TAdviceCaseStatus toSrc on b.AdviceCaseStatusIdTo = toSrc.AdviceCaseStatusId and toSrc.TenantId = c.IndigoClientId
			inner join CRM.dbo.TAdviceCaseStatusTransitionRule d on d.AdviceCaseStatusChangeId = c.AdviceCaseStatusChangeId
			where c.IndigoClientId = @SourceIndigoClientId
				and fromSrc.Descriptor = from1.Descriptor
				and toSrc.Descriptor = to1.Descriptor
				and d.AdviceCaseStatusRuleId = a.AdviceCaseStatusRuleId
			)

		-- delete missing Roles

		delete a
		output
			deleted.AdviceCaseStatusChangeRoleId, deleted.AdviceCaseStatusChangeId, deleted.RoleId, deleted.ConcurrencyId
			,'D', @Now, @StampUser
		into CRM.dbo.TAdviceCaseStatusChangeRoleAudit(
			AdviceCaseStatusChangeRoleId, AdviceCaseStatusChangeId, RoleId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from CRM.dbo.TAdviceCaseStatusChangeRole a
			inner join CRM.dbo.TAdviceCaseStatusChange b on b.AdviceCaseStatusChangeId = a.AdviceCaseStatusChangeId
			inner join CRM.dbo.TAdviceCaseStatus from1 on from1.AdviceCaseStatusId = b.AdviceCaseStatusIdFrom and from1.TenantId = b.IndigoClientId
			inner join CRM.dbo.TAdviceCaseStatus to1 on to1.AdviceCaseStatusId = b.AdviceCaseStatusIdTo and to1.TenantId = b.IndigoClientId
			inner join Administration.dbo.TRole r on r.RoleId = a.RoleId and r.IndigoClientId = b.IndigoClientId
		where b.IndigoClientId = @IndigoClientId
			and not exists( select 1 from CRM.dbo.TAdviceCaseStatusChange c
			inner join CRM.dbo.TAdviceCaseStatus fromSrc on fromSrc.AdviceCaseStatusId = c.AdviceCaseStatusIdFrom and fromSrc.TenantId = c.IndigoClientId
			inner join CRM.dbo.TAdviceCaseStatus toSrc on toSrc.AdviceCaseStatusId = c.AdviceCaseStatusIdTo and toSrc.TenantId = c.IndigoClientId
			inner join CRM.dbo.TAdviceCaseStatusChangeRole d on d.AdviceCaseStatusChangeId = c.AdviceCaseStatusChangeId
			inner join Administration.dbo.TRole rSrc on rSrc.RoleId = d.RoleId and rSrc.IndigoClientId = @SourceIndigoClientId
			where c.IndigoClientId = @SourceIndigoClientId
				and fromSrc.Descriptor = from1.Descriptor
				and toSrc.Descriptor = to1.Descriptor
				and rSrc.Identifier = r.Identifier
			)


		-- delete missing TAdviceCaseStatusChange
		delete a
		output
			deleted.AdviceCaseStatusChangeId, deleted.IndigoClientId, deleted.AdviceCaseStatusIdFrom, deleted.AdviceCaseStatusIdTo, deleted.ConcurrencyId
			,'D', @Now, @StampUser
		into CRM.dbo.TAdviceCaseStatusChangeAudit(
			AdviceCaseStatusChangeId, IndigoClientId, AdviceCaseStatusIdFrom, AdviceCaseStatusIdTo, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from CRM.dbo.TAdviceCaseStatusChange a
			inner join CRM.dbo.TAdviceCaseStatus from1 on from1.AdviceCaseStatusId = a.AdviceCaseStatusIdFrom and from1.TenantId = a.IndigoClientId
			inner join CRM.dbo.TAdviceCaseStatus to1 on a.AdviceCaseStatusIdTo = to1.AdviceCaseStatusId and to1.TenantId = a.IndigoClientId
		where a.IndigoClientId = @IndigoClientId
			and not exists( select 1 from CRM.dbo.TAdviceCaseStatusChange b
			inner join CRM.dbo.TAdviceCaseStatus fromSrc on b.AdviceCaseStatusIdFrom = fromSrc.AdviceCaseStatusId and fromSrc.TenantId = b.IndigoClientId
			inner join CRM.dbo.TAdviceCaseStatus toSrc on b.AdviceCaseStatusIdTo = toSrc.AdviceCaseStatusId and toSrc.TenantId = b.IndigoClientId
			where b.IndigoClientId = @SourceIndigoClientId
				and fromSrc.Descriptor = from1.Descriptor
				and toSrc.Descriptor = to1.Descriptor
			)

		-- Add TAdviceCaseStatusChange
		insert into CRM.dbo.TAdviceCaseStatusChange(IndigoClientId, AdviceCaseStatusIdFrom, AdviceCaseStatusIdTo, ConcurrencyId)
		output
			inserted.AdviceCaseStatusChangeId, inserted.IndigoClientId, inserted.AdviceCaseStatusIdFrom, inserted.AdviceCaseStatusIdTo, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into CRM.dbo.TAdviceCaseStatusChangeAudit(
			AdviceCaseStatusChangeId, IndigoClientId, AdviceCaseStatusIdFrom, AdviceCaseStatusIdTo, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select @IndigoClientId, from2.AdviceCaseStatusId, to2.AdviceCaseStatusId, 1
		from CRM.dbo.TAdviceCaseStatusChange a
			inner join CRM.dbo.TAdviceCaseStatus from1 on a.AdviceCaseStatusIdFrom = from1.AdviceCaseStatusId and from1.TenantId = a.IndigoClientId
			inner join CRM.dbo.TAdviceCaseStatus to1 on a.AdviceCaseStatusIdTo = to1.AdviceCaseStatusId and to1.TenantId = a.IndigoClientId
			inner join CRM.dbo.TAdviceCaseStatus from2 on from2.Descriptor = from1.Descriptor and from2.TenantId = @IndigoClientId
			inner join CRM.dbo.TAdviceCaseStatus to2 on to2.Descriptor = to1.Descriptor and to2.TenantId = @IndigoClientId
		where a.IndigoClientId = @SourceIndigoClientId
		except
		select IndigoClientId, AdviceCaseStatusIdFrom, AdviceCaseStatusIdTo, 1
		from CRM.dbo.TAdviceCaseStatusChange
		where IndigoClientId = @IndigoClientId

		-- Add Rules!
		insert into CRM.dbo.TAdviceCaseStatusTransitionRule(AdviceCaseStatusChangeId, AdviceCaseStatusRuleId, ConcurrencyId)
		select tgt.AdviceCaseStatusChangeId, d.AdviceCaseStatusRuleId, 1
		from CRM.dbo.TAdviceCaseStatusTransitionRule a
			inner join CRM.dbo.TAdviceCaseStatusChange b on b.AdviceCaseStatusChangeId = a.AdviceCaseStatusChangeId
			inner join CRM.dbo.TAdviceCaseStatus fromSrc on b.AdviceCaseStatusIdFrom = fromSrc.AdviceCaseStatusId and fromSrc.TenantId = b.IndigoClientId
			inner join CRM.dbo.TAdviceCaseStatus toSrc on b.AdviceCaseStatusIdTo = toSrc.AdviceCaseStatusId and toSrc.TenantId = b.IndigoClientId
			inner join CRM.dbo.TAdviceCaseStatusTransitionRule d on d.AdviceCaseStatusChangeId = a.AdviceCaseStatusChangeId

			inner join CRM.dbo.TAdviceCaseStatus fromTgt on fromTgt.Descriptor = fromSrc.Descriptor and fromTgt.TenantId = @IndigoClientId
			inner join CRM.dbo.TAdviceCaseStatus toTgt on toTgt.Descriptor = toSrc.Descriptor and toTgt.TenantId = @IndigoClientId
			inner join CRM.dbo.TAdviceCaseStatusChange tgt on tgt.AdviceCaseStatusIdFrom = fromTgt.AdviceCaseStatusId and tgt.AdviceCaseStatusIdTo = toTgt.AdviceCaseStatusId
		where b.IndigoClientId = @SourceIndigoClientId
			and tgt.IndigoClientId = @IndigoClientId
		except
		select a.AdviceCaseStatusChangeId, a.AdviceCaseStatusRuleId, 1
		from CRM.dbo.TAdviceCaseStatusTransitionRule a
		inner join CRM.dbo.TAdviceCaseStatusChange b on b.AdviceCaseStatusChangeId = a.AdviceCaseStatusChangeId
		where b.IndigoClientId = @IndigoClientId


		-- Add Roles!
		insert into CRM.dbo.TAdviceCaseStatusChangeRole(AdviceCaseStatusChangeId, RoleId, ConcurrencyId)
		output
			inserted.AdviceCaseStatusChangeRoleId, inserted.AdviceCaseStatusChangeId, inserted.RoleId, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into CRM.dbo.TAdviceCaseStatusChangeRoleAudit(
			AdviceCaseStatusChangeRoleId, AdviceCaseStatusChangeId, RoleId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select tgt.AdviceCaseStatusChangeId, rtgt.RoleId, 1
		from CRM.dbo.TAdviceCaseStatusChange a
			inner join CRM.dbo.TAdviceCaseStatus fromSrc on fromSrc.AdviceCaseStatusId = a.AdviceCaseStatusIdFrom and fromSrc.TenantId = a.IndigoClientId
			inner join CRM.dbo.TAdviceCaseStatus toSrc on toSrc.AdviceCaseStatusId = a.AdviceCaseStatusIdTo and toSrc.TenantId = a.IndigoClientId
			inner join CRM.dbo.TAdviceCaseStatusChangeRole d on d.AdviceCaseStatusChangeId = a.AdviceCaseStatusChangeId
			inner join Administration.dbo.TRole rSrc on rSrc.RoleId = d.RoleId and rSrc.IndigoClientId = @SourceIndigoClientId

			inner join CRM.dbo.TAdviceCaseStatus fromTgt on fromTgt.Descriptor = fromSrc.Descriptor and fromTgt.TenantId = @IndigoClientId
			inner join CRM.dbo.TAdviceCaseStatus toTgt on toTgt.Descriptor = toSrc.Descriptor and toTgt.TenantId = @IndigoClientId
			inner join CRM.dbo.TAdviceCaseStatusChange tgt on tgt.AdviceCaseStatusIdFrom = fromTgt.AdviceCaseStatusId and tgt.AdviceCaseStatusIdTo = toTgt.AdviceCaseStatusId
			inner join Administration.dbo.TRole rtgt on rtgt.Identifier = rSrc.Identifier and rtgt.IndigoClientId = @IndigoClientId
		where a.IndigoClientId = @SourceIndigoClientId
			and tgt.IndigoClientId = @IndigoClientId
		except
		select a.AdviceCaseStatusChangeId, a.RoleId, 1
		from CRM.dbo.TAdviceCaseStatusChangeRole a
		inner join Administration.dbo.TRole r on r.RoleId = a.RoleId
		where r.IndigoClientId = @IndigoClientId

		-- delete missing TAdviceCaseStatus : DM-2261
		delete a
		output
			deleted.AdviceCaseStatusId, deleted.TenantId, deleted.Descriptor, deleted.IsDefault, deleted.IsComplete, deleted.ConcurrencyId, deleted.IsAutoClose
			,'D', @Now, @StampUser
		into CRM.dbo.TAdviceCaseStatusAudit(AdviceCaseStatusId, TenantId, Descriptor, IsDefault, IsComplete, ConcurrencyId, IsAutoClose
			, StampAction, StampDateTime, StampUser)
		from CRM.dbo.TAdviceCaseStatus a
		left join CRM.dbo.TAdviceCaseStatus b on b.Descriptor = a.Descriptor and b.TenantId = @SourceIndigoClientId
		where a.TenantId = @IndigoClientId
		and b.AdviceCaseStatusId is null


		-- Compliance > Administration > File Checking > Grades
		update a
		set a.IsArchived = b.IsArchived,
			a.ConcurrencyId+=1
		output
			inserted.ComplianceGradeId, inserted.GradeName, inserted.IsArchived, inserted.TenantId, inserted.ConcurrencyId
			,'U', @Now, @StampUser
		into Compliance.dbo.TComplianceGradeAudit(
			ComplianceGradeId, GradeName, IsArchived, TenantId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from Compliance.dbo.TComplianceGrade a
		inner join Compliance.dbo.TComplianceGrade b on b.GradeName = a.GradeName and b.TenantId = @SourceIndigoClientId
		where a.TenantId = @IndigoClientId

		insert into Compliance.dbo.TComplianceGrade(GradeName, IsArchived, TenantId, ConcurrencyId)
		output
			inserted.ComplianceGradeId, inserted.GradeName, inserted.IsArchived, inserted.TenantId, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into Compliance.dbo.TComplianceGradeAudit(
			ComplianceGradeId, GradeName, IsArchived, TenantId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select GradeName, IsArchived, @IndigoClientId, 1
		from Compliance.dbo.TComplianceGrade
		where TenantId = @SourceIndigoClientId
		except
		select GradeName, IsArchived, TenantId, 1
		from Compliance.dbo.TComplianceGrade
		where TenantId = @IndigoClientId

		if @tx = 0 begin
			commit transaction TX
			set @msg=@ProcName+': commit transaction TX'
			raiserror(@msg,0,1) with nowait
		end

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
