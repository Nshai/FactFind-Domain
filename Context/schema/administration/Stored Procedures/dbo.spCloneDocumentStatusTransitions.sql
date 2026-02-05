SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCloneDocumentStatusTransitions] @IndigoClientId int, @SourceIndigoClientId int, @StampUser varchar(255) = '-1010'
as
begin
-- Administration > Documents > Setup > Status Order
-- Administration > Documents > Setup > Document Status
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

		update a
			set a.StatusOrder = b.StatusOrder, ConcurrencyId += 1
		output
			inserted.DocumentStatusOrderId, inserted.IndigoClientId, inserted.RefDocumentStatusId, inserted.StatusOrder, inserted.ConcurrencyId
			,'U', @Now, @StampUser
		into DocumentManagement.dbo.TDocumentStatusOrderAudit(DocumentStatusOrderId, IndigoClientId, RefDocumentStatusId, StatusOrder, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from DocumentManagement.dbo.TDocumentStatusOrder a
		inner join DocumentManagement.dbo.TDocumentStatusOrder b on b.RefDocumentStatusId = a.RefDocumentStatusId and b.IndigoClientId = @SourceIndigoClientId
		where a.IndigoClientId = @IndigoClientId
			and a.StatusOrder != b.StatusOrder

		insert into DocumentManagement.dbo.TDocumentStatusOrder(IndigoClientId, RefDocumentStatusId, StatusOrder, ConcurrencyId)
		output
			inserted.DocumentStatusOrderId, inserted.IndigoClientId, inserted.RefDocumentStatusId, inserted.StatusOrder, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into DocumentManagement.dbo.TDocumentStatusOrderAudit(DocumentStatusOrderId, IndigoClientId, RefDocumentStatusId, StatusOrder, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select @IndigoClientId, RefDocumentStatusId, StatusOrder, 1
		from DocumentManagement.dbo.TDocumentStatusOrder
		where IndigoClientId = @SourceIndigoClientId
		except
		select IndigoClientId, RefDocumentStatusId, StatusOrder, 1
		from DocumentManagement.dbo.TDocumentStatusOrder
		where IndigoClientId = @IndigoClientId

		delete a
		output
			deleted.DocumentStatusToRoleId, deleted.IndigoClientId, deleted.FromStatusId, deleted.ToStatusId, deleted.RoleId, deleted.ConcurrencyId
			,'D', @Now, @StampUser
		into DocumentManagement.dbo.TDocumentStatusToRoleAudit(DocumentStatusToRoleId, IndigoClientId, FromStatusId, ToStatusId, RoleId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from DocumentManagement.dbo.TDocumentStatusToRole a
		inner join Administration.dbo.TRole r on r.RoleId = a.RoleId and r.IndigoClientId = @IndigoClientId
		inner join DocumentManagement.dbo.TRefDocumentStatus fromStatus on fromStatus.RefDocumentStatusId = a.FromStatusId
		inner join DocumentManagement.dbo.TRefDocumentStatus toStatus on toStatus.RefDocumentStatusId = a.ToStatusId
		where a.IndigoClientId = @IndigoClientId
		and not exists(select 1 from DocumentManagement.dbo.TDocumentStatusToRole aSrc
			inner join Administration.dbo.TRole rSrc on rSrc.RoleId = aSrc.RoleId and rSrc.IndigoClientId = @SourceIndigoClientId
			inner join DocumentManagement.dbo.TRefDocumentStatus fromStatusSrc on fromStatusSrc.RefDocumentStatusId = aSrc.FromStatusId
			inner join DocumentManagement.dbo.TRefDocumentStatus toStatusSrc on toStatusSrc.RefDocumentStatusId = aSrc.ToStatusId
			where aSrc.IndigoClientId = @SourceIndigoClientId
				and rSrc.Identifier = r.Identifier
				and fromStatusSrc.RefDocumentStatusId = fromStatus.RefDocumentStatusId
				and toStatusSrc.RefDocumentStatusId = toStatus.RefDocumentStatusId)

		insert into DocumentManagement.dbo.TDocumentStatusToRole(IndigoClientId, FromStatusId, ToStatusId, RoleId, ConcurrencyId)
		output
			inserted.DocumentStatusToRoleId, inserted.IndigoClientId, inserted.FromStatusId, inserted.ToStatusId, inserted.RoleId, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into DocumentManagement.dbo.TDocumentStatusToRoleAudit(DocumentStatusToRoleId, IndigoClientId, FromStatusId, ToStatusId, RoleId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select @IndigoClientId, FromStatusId, ToStatusId, c.RoleId, 1
		from DocumentManagement.dbo.TDocumentStatusToRole a
		inner join Administration.dbo.TRole b on b.RoleId = a.RoleId and b.IndigoClientId = @SourceIndigoClientId
		inner join Administration.dbo.TRole c on c.Identifier = b.Identifier and c.IndigoClientId = @IndigoClientId
		where a.IndigoClientId = @SourceIndigoClientId
		except
		select IndigoClientId, FromStatusId, ToStatusId, RoleId, 1
		from DocumentManagement.dbo.TDocumentStatusToRole
		where IndigoClientId = @IndigoClientId

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
