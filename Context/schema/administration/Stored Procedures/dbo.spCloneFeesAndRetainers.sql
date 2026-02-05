SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCloneFeesAndRetainers] @IndigoClientId int, @SourceIndigoClientId int, @StampUser varchar(255) = '-1010'
as
begin
-- Compliance > Administration > Fees & Retainers
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
		-- Unique record
		update a
		set
			a.PassThroughTnCCheckingForFees = b.PassThroughTnCCheckingForFees,
			a.PassThroughTnCCheckingForRetainers = b.PassThroughTnCCheckingForRetainers
		output
			inserted.ComplianceSetupId, inserted.IndClientId, inserted.AcknolwdgeComplaintDays, inserted.ShdComplaintsNotifyUsersByEmail, inserted.ShdDocumentPredateSubmission, inserted.ShdQuotePredateSubmission, inserted.CanBeOwnTnCCoach
			, inserted.RequireTnCCoach, inserted.TnCCoachControlSpan, inserted.PractitionerRoleId, inserted.TnCRoleId, inserted.FileCheckRoleId, inserted.PassThroughTnCCheckingForFees, inserted.PassThroughTnCCheckingForRetainers
			, inserted.AdviceCaseCheckingEnabled, inserted.AssignToTncCoachForPreSale, inserted.AssignToTncCoachForPostSale, inserted.ComplianceGradeRoleId, inserted.DefaultServicingAdministratorToLoggedInUser
			, inserted.ConcurrencyId
			,'U', @Now, @StampUser
		into Compliance.dbo.TComplianceSetupAudit(
			ComplianceSetupId, IndClientId, AcknolwdgeComplaintDays, ShdComplaintsNotifyUsersByEmail, ShdDocumentPredateSubmission, ShdQuotePredateSubmission, CanBeOwnTnCCoach
			, RequireTnCCoach, TnCCoachControlSpan, PractitionerRoleId, TnCRoleId, FileCheckRoleId, PassThroughTnCCheckingForFees, PassThroughTnCCheckingForRetainers
			, AdviceCaseCheckingEnabled, AssignToTncCoachForPreSale, AssignToTncCoachForPostSale, ComplianceGradeRoleId, DefaultServicingAdministratorToLoggedInUser
			, ConcurrencyId
			,StampAction, StampDateTime, StampUser)
		from Compliance.dbo.TComplianceSetup a,
			Compliance.dbo.TComplianceSetup b
		where a.IndClientId = @IndigoClientId
			and b.IndClientId = @SourceIndigoClientId

		-- Delete existing assigned roles
		delete PolicyManagement.dbo.TFeeStatusTransitionToRole
		output
			deleted.FeeStatusTransitionToRoleId, deleted.FeeStatusTransitionId, deleted.TenantId, deleted.RoleId, deleted.ConcurrencyId
			,'D', @Now, @StampUser
		into PolicyManagement.dbo.TFeeStatusTransitionToRoleAudit(
			FeeStatusTransitionToRoleId, FeeStatusTransitionId, TenantId, RoleId, ConcurrencyId
			,StampAction, StampDateTime, StampUser)
		where TenantId = @IndigoClientId

		-- Assign Source Roles (joined by Identifier)
		insert into PolicyManagement.dbo.TFeeStatusTransitionToRole(FeeStatusTransitionId, TenantId, RoleId, ConcurrencyId)
		output
			inserted.FeeStatusTransitionToRoleId, inserted.FeeStatusTransitionId, inserted.TenantId, inserted.RoleId, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into PolicyManagement.dbo.TFeeStatusTransitionToRoleAudit(
			FeeStatusTransitionToRoleId, FeeStatusTransitionId, TenantId, RoleId, ConcurrencyId
			,StampAction, StampDateTime, StampUser)
		select distinct src.FeeStatusTransitionId, @IndigoClientId, trgtR.RoleId, 1
		from PolicyManagement.dbo.TFeeStatusTransitionToRole src
		inner join Administration..TRole srcR on srcR.RoleId = src.RoleId and srcR.IndigoClientId = @SourceIndigoClientId
		inner join Administration..TRole trgtR on trgtR.Identifier = srcR.Identifier and trgtR.IndigoClientId = @IndigoClientId
		where src.TenantId = @SourceIndigoClientId

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
