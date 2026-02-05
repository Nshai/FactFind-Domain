SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc dbo.spCloneDuplicateClientSettings @IndigoClientId int, @SourceIndigoClientId int, @StampUser varchar(255) = '-1010'
as
begin
-- Service cases categories, statuses, transitions, auto-close and automated fee model creation setting

-- Admininstration > Organisation > Groups > Option Duplicate Client Settings
-- Configure Settings AddClientWizard: Entire Company
-- Configure Settings FisrtNameMatchingCriteria: Wildcard search on initial
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

		declare @IndigoClientGuid uniqueidentifier

		select @IndigoClientGuid = [guid]
		from Administration..TIndigoClient
		where IndigoClientId = @IndigoClientId

		-- Remove existing settings
		delete a
		output
			deleted.IndigoClientPreferenceId, deleted.IndigoClientId, deleted.IndigoClientGuid, deleted.PreferenceName, deleted.[Value], deleted.[Disabled], deleted.[Guid], deleted.ConcurrencyId
			,'D', @Now, @StampUser
		into Administration..TIndigoClientPreferenceAudit(IndigoClientPreferenceId, IndigoClientId, IndigoClientGuid, PreferenceName, [Value], [Disabled], [Guid], ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from Administration.dbo.TIndigoClientPreference a
		inner join Administration.dbo.TIndigoClientPreference b on b.PreferenceName = a.PreferenceName and b.IndigoClientId = @SourceIndigoClientId
		where b.PreferenceName in ('AddClient_DuplicateChecking_SearchType','AddClient_DuplicateChecking',
			'DisplayLegacyExpectation','EnableExpectation','Feature_HasOldAdviceProcess','feature_ioreskin','EnableInAppSupport')
		and a.IndigoClientId = @IndigoClientId

		-- Copy source settings
		insert into Administration.dbo.TIndigoClientPreference(IndigoClientId, IndigoClientGuid, PreferenceName, [Value], [Disabled], ConcurrencyId)
		output
			inserted.IndigoClientPreferenceId, inserted.IndigoClientId, inserted.IndigoClientGuid, inserted.PreferenceName, inserted.[Value], inserted.[Disabled], inserted.[Guid], inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into 	Administration.dbo.TIndigoClientPreferenceAudit(IndigoClientPreferenceId, IndigoClientId, IndigoClientGuid, PreferenceName, [Value], [Disabled], [Guid], ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select @IndigoClientId, @IndigoClientGuid, PreferenceName, [Value], [Disabled], 1
		from Administration.dbo.TIndigoClientPreference
		where IndigoClientId = @SourceIndigoClientId
			and PreferenceName in ('AddClient_DuplicateChecking_SearchType','AddClient_DuplicateChecking',
			'DisplayLegacyExpectation','EnableExpectation','Feature_HasOldAdviceProcess','feature_ioreskin','EnableInAppSupport')


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
