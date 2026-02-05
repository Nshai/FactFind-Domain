SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCloneDocumentDeleteRights] @IndigoClientId int, @SourceIndigoClientId int, @StampUser varchar(255) = '-1010'
as
begin
-- Administration > Documents > Setup > Delete Rights
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
			deleted.DocumentDeleteRightsToRoleId, deleted.IndigoClientId, deleted.DocumentStatusId, deleted.BinderStatusId, deleted.RoleId, deleted.ConcurrencyId
			,'C', @Now, @StampUser
		into DocumentManagement.dbo.TDocumentDeleteRightsToRoleAudit(DocumentDeleteRightsToRoleId, IndigoClientId, DocumentStatusId, BinderStatusId, RoleId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from DocumentManagement.dbo.TDocumentDeleteRightsToRole a
			inner join Administration.dbo.TRole r on r.RoleId = a.RoleId and r.IndigoClientId = @IndigoClientId
		where a.IndigoClientId = @IndigoClientId
			and not exists(select 1 from DocumentManagement.dbo.TDocumentDeleteRightsToRole aSrc
				inner join Administration.dbo.TRole rSrc on rSrc.RoleId = aSrc.RoleId and rSrc.IndigoClientId = @SourceIndigoClientId
				where aSrc.IndigoClientId = @SourceIndigoClientId
				and rSrc.Identifier = r.Identifier
				and aSrc.DocumentStatusId = a.DocumentStatusId
				and aSrc.BinderStatusId = a.BinderStatusId)

		insert into DocumentManagement.dbo.TDocumentDeleteRightsToRole(IndigoClientId, DocumentStatusId, BinderStatusId, RoleId, ConcurrencyId)
		output
			inserted.DocumentDeleteRightsToRoleId, inserted.IndigoClientId, inserted.DocumentStatusId, inserted.BinderStatusId, inserted.RoleId, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into DocumentManagement.dbo.TDocumentDeleteRightsToRoleAudit(DocumentDeleteRightsToRoleId, IndigoClientId, DocumentStatusId, BinderStatusId, RoleId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select @IndigoClientId, DocumentStatusId, BinderStatusId, c.RoleId, 1
		from DocumentManagement.dbo.TDocumentDeleteRightsToRole a
		inner join Administration.dbo.TRole b on b.RoleId = a.RoleId and b.IndigoClientId = @SourceIndigoClientId
		inner join Administration.dbo.TRole c on c.Identifier = b.Identifier and c.IndigoClientId = @IndigoClientId
		where a.IndigoClientId = @SourceIndigoClientId
		except
		select IndigoClientId, DocumentStatusId, BinderStatusId, RoleId, 1
		from DocumentManagement.dbo.TDocumentDeleteRightsToRole
		where IndigoClientId = @IndigoClientId

		-- Add Delete rigths without roles
		insert into DocumentManagement.dbo.TDocumentDeleteRightsToRole(IndigoClientId, DocumentStatusId, BinderStatusId, ConcurrencyId)
		output
			inserted.DocumentDeleteRightsToRoleId, inserted.IndigoClientId, inserted.DocumentStatusId, inserted.BinderStatusId, inserted.RoleId, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into DocumentManagement.dbo.TDocumentDeleteRightsToRoleAudit(DocumentDeleteRightsToRoleId, IndigoClientId, DocumentStatusId, BinderStatusId, RoleId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select @IndigoClientId, DocumentStatusId, BinderStatusId, 1
		from DocumentManagement.dbo.TDocumentDeleteRightsToRole a
		where a.IndigoClientId = @SourceIndigoClientId
			and a.RoleId is null
		except
		select IndigoClientId, DocumentStatusId, BinderStatusId, 1
		from DocumentManagement.dbo.TDocumentDeleteRightsToRole
		where IndigoClientId = @IndigoClientId
			and RoleId is null

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
