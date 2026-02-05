SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spClonePlanPurpose] @IndigoClientId int, @SourceIndigoClientId int, @StampUser varchar(255) = '-1010'
as
begin
-- Plan purposes
-- Compliance > Administration > Registers > Plan Purposes (and also Plan Types > Manage Plan Purposes)
	set nocount on
	declare @ProcName sysname = OBJECT_NAME(@@PROCID),
		@procResult int
	exec @procResult = dbo.spStartCreateTenantModule @IndigoClientId, @SourceIndigoClientId, @ProcName
	if @procResult!=0 return

	declare @tx int,
		@Now datetime = GetDate(),
		@PlanPurposeId int = 0,
		@msg varchar(max)

	declare @Updated table (PlanPurposeId int)


	select @tx = @@TRANCOUNT

	if @tx = 0 begin
		set @msg=@ProcName+': begin transaction TX'
		raiserror(@msg,0,1) with nowait
		begin transaction TX
	end

	begin try

		update a
		set a.MortgageRelatedfg = b.MortgageRelatedfg,
			a.ConcurrencyId += 1
		output
			inserted.PlanPurposeId
		into
			@Updated(PlanPurposeId)
		from PolicyManagement.dbo.TPlanPurpose a
		inner join PolicyManagement.dbo.TPlanPurpose b on b.Descriptor = a.Descriptor and b.IndigoClientId = @SourceIndigoClientId
		where a.IndigoClientId = @IndigoClientId
			--and isnull(convert( int, a.MortgageRelatedfg),-1) != isnull(convert( int, b.MortgageRelatedfg),-1)


		while (1=1) begin
			Select top 1 @PlanPurposeId = PlanPurposeId
			from @Updated
			where PlanPurposeId > @PlanPurposeId
			order by PlanPurposeId

			if @@rowcount=0 break

			exec PolicyManagement.dbo.SpNAuditPlanPurpose @StampUser=@StampUser, @PlanPurposeId=@PlanPurposeId, @StampAction='U'

			delete a
			output
				deleted.PlanTypePurposeId, deleted.RefPlanTypeId, deleted.PlanPurposeId, deleted.DefaultFg, deleted.ConcurrencyId, deleted.RefPlanType2ProdSubTypeId
				,'D', @Now, @StampUser
			into PolicyManagement.dbo.TPlanTypePurposeAudit(PlanTypePurposeId, RefPlanTypeId, PlanPurposeId, DefaultFg, ConcurrencyId, RefPlanType2ProdSubTypeId
				, StampAction, StampDateTime, StampUser)
			from PolicyManagement.dbo.TPlanTypePurpose a
			where PlanPurposeId = @PlanPurposeId

			-- Copy new TPlanTypePurpose
			insert into PolicyManagement.dbo.TPlanTypePurpose(RefPlanTypeId, PlanPurposeId, DefaultFg, RefPlanType2ProdSubTypeId, ConcurrencyId)
			output
				inserted.PlanTypePurposeId, inserted.RefPlanTypeId, inserted.PlanPurposeId, inserted.DefaultFg, inserted.ConcurrencyId, inserted.RefPlanType2ProdSubTypeId
				,'C', @Now, @StampUser
			into PolicyManagement.dbo.TPlanTypePurposeAudit(PlanTypePurposeId, RefPlanTypeId, PlanPurposeId, DefaultFg, ConcurrencyId, RefPlanType2ProdSubTypeId
				, StampAction, StampDateTime, StampUser)
			select a.RefPlanTypeId, trgt.PlanPurposeId, a.DefaultFg, a.RefPlanType2ProdSubTypeId, 1
			from PolicyManagement.dbo.TPlanTypePurpose a
				inner join PolicyManagement.dbo.TPlanPurpose src on src.PlanPurposeId = a.PlanPurposeId and src.IndigoClientId = @SourceIndigoClientId
				inner join PolicyManagement.dbo.TPlanPurpose trgt on trgt.Descriptor = src.Descriptor and trgt.MortgageRelatedfg = src.MortgageRelatedfg
			where trgt.IndigoClientId = @IndigoClientId
				and trgt.PlanPurposeId = @PlanPurposeId

		end

		delete @Updated
		set @PlanPurposeId = 0

		-- This may cause duplicates to be added! MortgageRelatedfg is NULL
		insert into PolicyManagement.dbo.TPlanPurpose(Descriptor, MortgageRelatedfg, IndigoClientId, ConcurrencyId)
		output
			inserted.PlanPurposeId
		into
			@Updated(PlanPurposeId)
		select Descriptor, MortgageRelatedfg, @IndigoClientId, 1
		from PolicyManagement.dbo.TPlanPurpose
		where IndigoClientId = @SourceIndigoClientId
		except
		select Descriptor, MortgageRelatedfg, IndigoClientId, 1
		from PolicyManagement.dbo.TPlanPurpose
		where IndigoClientId = @IndigoClientId

		while (1=1) begin
			Select top 1 @PlanPurposeId = PlanPurposeId
			from @Updated
			where PlanPurposeId > @PlanPurposeId
			order by PlanPurposeId

			if @@rowcount=0 break

			exec PolicyManagement.dbo.SpNAuditPlanPurpose @StampUser=@StampUser, @PlanPurposeId=@PlanPurposeId, @StampAction='C'

			--Copy new TPlanTypePurpose
			insert into PolicyManagement.dbo.TPlanTypePurpose(RefPlanTypeId, PlanPurposeId, DefaultFg, RefPlanType2ProdSubTypeId, ConcurrencyId)
			output
				inserted.PlanTypePurposeId, inserted.RefPlanTypeId, inserted.PlanPurposeId, inserted.DefaultFg, inserted.ConcurrencyId, inserted.RefPlanType2ProdSubTypeId
				,'C', @Now, @StampUser
			into PolicyManagement.dbo.TPlanTypePurposeAudit(PlanTypePurposeId, RefPlanTypeId, PlanPurposeId, DefaultFg, ConcurrencyId, RefPlanType2ProdSubTypeId
				, StampAction, StampDateTime, StampUser)
			select a.RefPlanTypeId, trgt.PlanPurposeId, a.DefaultFg, a.RefPlanType2ProdSubTypeId, 1
			from PolicyManagement.dbo.TPlanTypePurpose a
			inner join PolicyManagement.dbo.TPlanPurpose src on src.PlanPurposeId = a.PlanPurposeId and src.IndigoClientId = @SourceIndigoClientId
			inner join PolicyManagement.dbo.TPlanPurpose trgt on trgt.Descriptor = src.Descriptor and trgt.MortgageRelatedfg = src.MortgageRelatedfg
			where trgt.IndigoClientId = @IndigoClientId
			and trgt.PlanPurposeId = @PlanPurposeId

		end

		if @tx = 0 begin
			commit transaction TX
			set @msg=@ProcName+': commit transaction TX'
			raiserror(@msg,0,1) with nowait
		end

		exec dbo.spStopCreateTenantModule @IndigoClientId, @SourceIndigoClientId, @ProcName
		if object_id('tempdb.#InsertOutput') is not null drop table #InsertOutput
		
	end try
	begin catch
		declare @Errmsg varchar(max) = @ProcName+'
'+ERROR_MESSAGE()

		if @tx = 0 begin
			set @msg=@ProcName+': rollback transaction TX'
			raiserror(@msg,0,1) with nowait
			rollback transaction TX
		end
		if object_id('tempdb.#InsertOutput') is not null drop table #InsertOutput
		raiserror(@Errmsg,16,1)
	end catch
end
GO
