SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCloneDocumentBinderTransitions] @IndigoClientId int, @SourceIndigoClientId int, @StampUser varchar(255) = '-1010'
as
begin
-- Administration > Documents > Setup > Binder Status
-- Administration > Documents > Setup > Binder Setting
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

		delete a
		output
			deleted.BinderStatusToRoleId, deleted.IndigoClientId, deleted.FromStatusId, deleted.ToStatusId, deleted.RoleId, deleted.ConcurrencyId, deleted.AreDocumentsFinal
			,'D', @Now, @StampUser
		into DocumentManagement.dbo.TBinderStatusToRoleAudit(BinderStatusToRoleId, IndigoClientId, FromStatusId, ToStatusId, RoleId, ConcurrencyId, AreDocumentsFinal
			, StampAction, StampDateTime, StampUser)
		from DocumentManagement.dbo.TBinderStatusToRole a
			inner join Administration.dbo.TRole r on r.RoleId = a.RoleId and r.IndigoClientId = @IndigoClientId
		where a.IndigoClientId = @IndigoClientId
			and not exists(select 1 from DocumentManagement.dbo.TBinderStatusToRole aSrc
				inner join Administration.dbo.TRole rSrc on rSrc.RoleId = aSrc.RoleId and rSrc.IndigoClientId = @SourceIndigoClientId
				where aSrc.IndigoClientId = @SourceIndigoClientId
				and rSrc.Identifier = r.Identifier
				and aSrc.AreDocumentsFinal = a.AreDocumentsFinal
				and aSrc.FromStatusId = a.FromStatusId
				and aSrc.ToStatusId = a.ToStatusId)

		insert into DocumentManagement.dbo.TBinderStatusToRole(IndigoClientId, FromStatusId, ToStatusId, RoleId, ConcurrencyId, AreDocumentsFinal)
		output
			inserted.BinderStatusToRoleId, inserted.IndigoClientId, inserted.FromStatusId, inserted.ToStatusId, inserted.RoleId, inserted.ConcurrencyId, inserted.AreDocumentsFinal
			,'C', @Now, @StampUser
		into DocumentManagement.dbo.TBinderStatusToRoleAudit(BinderStatusToRoleId, IndigoClientId, FromStatusId, ToStatusId, RoleId, ConcurrencyId, AreDocumentsFinal
			, StampAction, StampDateTime, StampUser)
		select @IndigoClientId, FromStatusId, ToStatusId, c.RoleId, 1, AreDocumentsFinal
		from DocumentManagement.dbo.TBinderStatusToRole a
		inner join Administration.dbo.TRole b on b.RoleId = a.RoleId and b.IndigoClientId = @SourceIndigoClientId
		inner join Administration.dbo.TRole c on c.Identifier = b.Identifier and c.IndigoClientId = @IndigoClientId
		where a.IndigoClientId = @SourceIndigoClientId
		except
		select IndigoClientId, FromStatusId, ToStatusId, RoleId, 1, AreDocumentsFinal
		from DocumentManagement.dbo.TBinderStatusToRole
		where IndigoClientId = @IndigoClientId


		update a
		set a.ConcurrencyId +=1,
			a.CanAutomaticallyCreateBinder = b.CanAutomaticallyCreateBinder,
			a.NamingConvention = b.NamingConvention,
			a.AllowOneBinderPerOneUniqueOpportunity = b.AllowOneBinderPerOneUniqueOpportunity,
			a.AllowSameBinderToBeLinkedToMultipleOpportunities = b.AllowSameBinderToBeLinkedToMultipleOpportunities,
			a.DoNotAllowDeleteBinderWithDocuments = b.DoNotAllowDeleteBinderWithDocuments,
			a.DoNotAllowSameBinderToBeLinkedToMultipleServiceCases = b.DoNotAllowSameBinderToBeLinkedToMultipleServiceCases
		output
			inserted.BinderSettingId,
			inserted.CanAutomaticallyCreateBinder,
			inserted.NamingConvention,
			inserted.AllowOneBinderPerOneUniqueOpportunity,
			inserted.AllowSameBinderToBeLinkedToMultipleOpportunities,
			inserted.DoNotAllowDeleteBinderWithDocuments,
			inserted.IndigoClientId,
			inserted.ConcurrencyId,
			inserted.DoNotAllowSameBinderToBeLinkedToMultipleServiceCases
			,'U', @Now, @StampUser
		into DocumentManagement.dbo.TBinderSettingAudit(
			BinderSettingId,
			CanAutomaticallyCreateBinder,
			NamingConvention,
			AllowOneBinderPerOneUniqueOpportunity,
			AllowSameBinderToBeLinkedToMultipleOpportunities,
			DoNotAllowDeleteBinderWithDocuments,
			IndigoClientId,
			ConcurrencyId,
			DoNotAllowSameBinderToBeLinkedToMultipleServiceCases
			, StampAction, StampDateTime, StampUser)
		from DocumentManagement.dbo.TBinderSetting a, DocumentManagement.dbo.TBinderSetting b
		where a.IndigoClientId = @IndigoClientId
			and b.IndigoClientId = @SourceIndigoClientId

		if @@ROWCOUNT = 0 begin
			insert into DocumentManagement.dbo.TBinderSetting(
				CanAutomaticallyCreateBinder,
				NamingConvention,
				AllowOneBinderPerOneUniqueOpportunity,
				AllowSameBinderToBeLinkedToMultipleOpportunities,
				DoNotAllowDeleteBinderWithDocuments,
				IndigoClientId,
				ConcurrencyId,
				DoNotAllowSameBinderToBeLinkedToMultipleServiceCases)
			output
				inserted.BinderSettingId,
				inserted.CanAutomaticallyCreateBinder,
				inserted.NamingConvention,
				inserted.AllowOneBinderPerOneUniqueOpportunity,
				inserted.AllowSameBinderToBeLinkedToMultipleOpportunities,
				inserted.DoNotAllowDeleteBinderWithDocuments,
				inserted.IndigoClientId,
				inserted.ConcurrencyId,
				inserted.DoNotAllowSameBinderToBeLinkedToMultipleServiceCases
				,'C', @Now, @StampUser
			into DocumentManagement.dbo.TBinderSettingAudit(
				BinderSettingId,
				CanAutomaticallyCreateBinder,
				NamingConvention,
				AllowOneBinderPerOneUniqueOpportunity,
				AllowSameBinderToBeLinkedToMultipleOpportunities,
				DoNotAllowDeleteBinderWithDocuments,
				IndigoClientId,
				ConcurrencyId,
				DoNotAllowSameBinderToBeLinkedToMultipleServiceCases
				, StampAction, StampDateTime, StampUser)
			select CanAutomaticallyCreateBinder,
					NamingConvention,
					AllowOneBinderPerOneUniqueOpportunity,
					AllowSameBinderToBeLinkedToMultipleOpportunities,
					DoNotAllowDeleteBinderWithDocuments,
					@IndigoClientId,
					1,
					DoNotAllowSameBinderToBeLinkedToMultipleServiceCases
			from DocumentManagement.dbo.TBinderSetting
			where IndigoClientId = @SourceIndigoClientId
			except
			select CanAutomaticallyCreateBinder,
					NamingConvention,
					AllowOneBinderPerOneUniqueOpportunity,
					AllowSameBinderToBeLinkedToMultipleOpportunities,
					DoNotAllowDeleteBinderWithDocuments,
					IndigoClientId,
					1,
					DoNotAllowSameBinderToBeLinkedToMultipleServiceCases
			from DocumentManagement.dbo.TBinderSetting
			where IndigoClientId = @IndigoClientId
		end

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
