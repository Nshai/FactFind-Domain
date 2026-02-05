SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCloneChecklistCategoriesAndQuestions] @IndigoClientId int, @SourceIndigoClientId int, @StampUser varchar(255) = '-1010'
as
begin
-- Administration > Organisation > Fact Find > Mortgage Checklist Categories
-- Administration > Organisation > Fact Find > Checklist Questions
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
		set a.ArchiveFG = b.ArchiveFG,
			a.Ordinal = b.Ordinal,
			a.SystemFG = b.SystemFG,
			a.ConcurrencyId +=1
		output
			inserted.MortgageChecklistCategoryId, inserted.MortgageChecklistCategoryName, inserted.TenantId, inserted.ArchiveFG, inserted.Ordinal, inserted.SystemFG, inserted.ConcurrencyId
			,'U', @Now, @StampUser
		into administration.dbo.TMortgageChecklistCategoryAudit(MortgageChecklistCategoryId, MortgageChecklistCategoryName, TenantId, ArchiveFG, Ordinal, SystemFG, ConcurrencyId
			, StampAction, StampDateTime, StampUser)

		from administration.dbo.TMortgageChecklistCategory a
			inner join administration.dbo.TMortgageChecklistCategory b on b.MortgageChecklistCategoryName = a.MortgageChecklistCategoryName and b.TenantId = @SourceIndigoClientId
		where a.TenantId = @IndigoClientId
			and (a.ArchiveFG != b.ArchiveFG
				or a.Ordinal != b.Ordinal
				or a.SystemFG != b.SystemFG)

		insert into administration.dbo.TMortgageChecklistCategory(MortgageChecklistCategoryName, TenantId, ArchiveFG, Ordinal, SystemFG, ConcurrencyId)
		output
			inserted.MortgageChecklistCategoryId, inserted.MortgageChecklistCategoryName, inserted.TenantId, inserted.ArchiveFG, inserted.Ordinal, inserted.SystemFG, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into administration.dbo.TMortgageChecklistCategoryAudit(MortgageChecklistCategoryId, MortgageChecklistCategoryName, TenantId, ArchiveFG, Ordinal, SystemFG, ConcurrencyId
			, StampAction, StampDateTime, StampUser)

		select MortgageChecklistCategoryName, @IndigoClientId, ArchiveFG, Ordinal, SystemFG, 1
		from administration.dbo.TMortgageChecklistCategory
		where TenantId = @SourceIndigoClientId
		except
		select MortgageChecklistCategoryName, TenantId, ArchiveFG, Ordinal, SystemFG, 1
		from administration.dbo.TMortgageChecklistCategory
		where TenantId = @IndigoClientId


		-- "Move down" any duplicate Ordinal
		while(1=1) begin
		;with duplicates
			as (select *,
				row_number() OVER ( PARTITION BY TenantId, Ordinal
				ORDER BY MortgageChecklistCategoryId) AS nr
				from administration.dbo.TMortgageChecklistCategory with(nolock)
				where TenantId = @IndigoClientId
			)
			update duplicates
			set Ordinal += 1 -- nr
			where nr > 1
			if @@rowcount=0 break
		end

		update a
		set a.Ordinal = c.Ordinal,
			a.IsArchived = c.IsArchived,
			a.SystemFG = c.SystemFG,
			a.ConcurrencyId +=1
		output
			inserted.MortgageChecklistQuestionId, inserted.Question, inserted.MortgageChecklistCategoryId, inserted.Ordinal, inserted.IsArchived, inserted.TenantId, inserted.ParentQuestionId, inserted.SystemFG, inserted.ConcurrencyId
			,'U', @Now, @StampUser
		into administration.dbo.TMortgageChecklistQuestionAudit(MortgageChecklistQuestionId, Question, MortgageChecklistCategoryId, Ordinal, IsArchived, TenantId, ParentQuestionId, SystemFG, ConcurrencyId
			, StampAction, StampDateTime, StampUser)

		from administration.dbo.TMortgageChecklistQuestion a
		inner join administration.dbo.TMortgageChecklistCategory b on b.MortgageChecklistCategoryId = a.MortgageChecklistCategoryId and b.TenantId = @IndigoClientId
		inner join administration.dbo.TMortgageChecklistQuestion c on c.Question = a.Question and c.TenantId = @SourceIndigoClientId
		inner join administration.dbo.TMortgageChecklistCategory d on d.MortgageChecklistCategoryId = c.MortgageChecklistCategoryId and d.TenantId = @SourceIndigoClientId
		where a.TenantId = @IndigoClientId
			and a.ParentQuestionId is null
			and c.ParentQuestionId is null
			and b.MortgageChecklistCategoryName = d.MortgageChecklistCategoryName
			and (a.Ordinal != c.Ordinal
				or a.IsArchived != c.IsArchived
				or a.SystemFG != c.SystemFG
				)

		update a
		set a.Ordinal = c.Ordinal,
			a.IsArchived = c.IsArchived,
			a.SystemFG = c.SystemFG,
			a.ConcurrencyId +=1
		output
			inserted.MortgageChecklistQuestionId, inserted.Question, inserted.MortgageChecklistCategoryId, inserted.Ordinal, inserted.IsArchived, inserted.TenantId, inserted.ParentQuestionId, inserted.SystemFG, inserted.ConcurrencyId
			,'U', @Now, @StampUser
		into administration.dbo.TMortgageChecklistQuestionAudit(MortgageChecklistQuestionId, Question, MortgageChecklistCategoryId, Ordinal, IsArchived, TenantId, ParentQuestionId, SystemFG, ConcurrencyId
			, StampAction, StampDateTime, StampUser)

		from administration.dbo.TMortgageChecklistQuestion a
		inner join administration.dbo.TMortgageChecklistCategory b on b.MortgageChecklistCategoryId = a.MortgageChecklistCategoryId and b.TenantId = @IndigoClientId
		inner join administration.dbo.TMortgageChecklistQuestion c on c.Question = a.Question and c.TenantId = @SourceIndigoClientId
		inner join administration.dbo.TMortgageChecklistCategory d on d.MortgageChecklistCategoryId = c.MortgageChecklistCategoryId and d.TenantId = @SourceIndigoClientId

		-- Parent
		inner join administration.dbo.TMortgageChecklistQuestion e on e.MortgageChecklistQuestionId = a.ParentQuestionId and e.TenantId = @IndigoClientId
		inner join administration.dbo.TMortgageChecklistCategory f on b.MortgageChecklistCategoryId = e.MortgageChecklistCategoryId and f.TenantId = @IndigoClientId

		inner join administration.dbo.TMortgageChecklistQuestion g on g.MortgageChecklistQuestionId = c.ParentQuestionId and g.TenantId = @SourceIndigoClientId
		inner join administration.dbo.TMortgageChecklistCategory h on h.MortgageChecklistCategoryId = g.MortgageChecklistCategoryId and h.TenantId = @SourceIndigoClientId

		where a.TenantId = @IndigoClientId
			and a.ParentQuestionId is not null
			and c.ParentQuestionId is not null
			and b.MortgageChecklistCategoryName = d.MortgageChecklistCategoryName
			and f.MortgageChecklistCategoryName = h.MortgageChecklistCategoryName
			and (a.Ordinal != c.Ordinal
				or a.IsArchived != c.IsArchived
				or a.SystemFG != c.SystemFG
				)



		insert into administration.dbo.TMortgageChecklistQuestion(Question, MortgageChecklistCategoryId, Ordinal, IsArchived, TenantId, ParentQuestionId, SystemFG, ConcurrencyId)
		output
			inserted.MortgageChecklistQuestionId, inserted.Question, inserted.MortgageChecklistCategoryId, inserted.Ordinal, inserted.IsArchived, inserted.TenantId, inserted.ParentQuestionId, inserted.SystemFG, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into administration.dbo.TMortgageChecklistQuestionAudit(MortgageChecklistQuestionId, Question, MortgageChecklistCategoryId, Ordinal, IsArchived, TenantId, ParentQuestionId, SystemFG, ConcurrencyId
			, StampAction, StampDateTime, StampUser)

		select a.Question, c.MortgageChecklistCategoryId, a.Ordinal, a.IsArchived, @IndigoClientId, NULL, a.SystemFG, 1
		from administration.dbo.TMortgageChecklistQuestion a
		inner join administration.dbo.TMortgageChecklistCategory b on b.MortgageChecklistCategoryId = a.MortgageChecklistCategoryId and b.TenantId = @SourceIndigoClientId
		cross apply (select top 1 * from administration.dbo.TMortgageChecklistCategory c where c.MortgageChecklistCategoryName = b.MortgageChecklistCategoryName
			and c.ArchiveFG = b.ArchiveFG and c.SystemFG = b.SystemFG and c.TenantId = @IndigoClientId
			and isnull(c.Ordinal,0) = isnull(b.Ordinal,0)
			order by MortgageChecklistCategoryId)c
		where a.TenantId = @SourceIndigoClientId
			and a.ParentQuestionId is null
		except
		select Question, MortgageChecklistCategoryId, Ordinal, IsArchived, TenantId, ParentQuestionId, SystemFG, 1
		from administration.dbo.TMortgageChecklistQuestion
		where TenantId = @IndigoClientId
			and ParentQuestionId is null

		insert into administration.dbo.TMortgageChecklistQuestion(Question, MortgageChecklistCategoryId, Ordinal, IsArchived, TenantId, ParentQuestionId, SystemFG, ConcurrencyId)
		output
			inserted.MortgageChecklistQuestionId, inserted.Question, inserted.MortgageChecklistCategoryId, inserted.Ordinal, inserted.IsArchived, inserted.TenantId, inserted.ParentQuestionId, inserted.SystemFG, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into administration.dbo.TMortgageChecklistQuestionAudit(MortgageChecklistQuestionId, Question, MortgageChecklistCategoryId, Ordinal, IsArchived, TenantId, ParentQuestionId, SystemFG, ConcurrencyId
			, StampAction, StampDateTime, StampUser)

		select a.Question, e.MortgageChecklistCategoryId, a.Ordinal, a.IsArchived, @IndigoClientId, f.MortgageChecklistQuestionId, a.SystemFG, 1
		from
			-- Source
			administration.dbo.TMortgageChecklistQuestion a -- Question, Ordinal, IsArchived, SystemFG
			inner join administration.dbo.TMortgageChecklistCategory b on b.MortgageChecklistCategoryId = a.MortgageChecklistCategoryId and b.TenantId = @SourceIndigoClientId -- MortgageChecklistCategoryId
			inner join administration.dbo.TMortgageChecklistQuestion c on c.MortgageChecklistQuestionId = a.ParentQuestionId and c.TenantId = @SourceIndigoClientId -- ParentId
			inner join administration.dbo.TMortgageChecklistCategory d on d. MortgageChecklistCategoryId = c.MortgageChecklistCategoryId and d.TenantId = @SourceIndigoClientId -- MortgageChecklistCategoryId for Parent

			-- Target Parent
			inner join administration.dbo.TMortgageChecklistCategory e on e.MortgageChecklistCategoryName = d.MortgageChecklistCategoryName
				and e.ArchiveFG = b.ArchiveFG and e.SystemFG = b.SystemFG and e.TenantId = @IndigoClientId and isnull(e.Ordinal,0) = isnull(b.Ordinal,0)
			inner join administration.dbo.TMortgageChecklistQuestion f on f.Question = c.Question and f.MortgageChecklistCategoryId = e.MortgageChecklistCategoryId
				and f.IsArchived = c.IsArchived and f.Ordinal = c.Ordinal and f.SystemFG = c.SystemFG and e.TenantId = @IndigoClientId

		where a.TenantId = @SourceIndigoClientId
			and a.ParentQuestionId is not null
		except
		select Question, MortgageChecklistCategoryId, Ordinal, IsArchived, TenantId, ParentQuestionId, SystemFG, 1
		from administration.dbo.TMortgageChecklistQuestion
		where TenantId = @IndigoClientId
			and ParentQuestionId is not null

		-- "Move down" any duplicate Ordinal
		while(1=1) begin
		;with duplicates
			as (select *,
				row_number() OVER ( PARTITION BY TenantId, MortgageChecklistCategoryId, Ordinal
				ORDER BY MortgageChecklistCategoryId, MortgageChecklistQuestionId) AS nr
				from administration.dbo.TMortgageChecklistQuestion with(nolock)
				where TenantId = @IndigoClientId
				and ParentQuestionId is null
				and Ordinal is not null
			)
			update duplicates
			set Ordinal += 1 -- nr
			where nr > 1
			if @@rowcount=0 break
		end

		-- Those with parent
		while(1=1) begin
		;with duplicates
			as (select *,
				row_number() OVER ( PARTITION BY TenantId, MortgageChecklistCategoryId, ParentQuestionId, Ordinal
				ORDER BY MortgageChecklistCategoryId, MortgageChecklistQuestionId) AS nr
				from administration.dbo.TMortgageChecklistQuestion with(nolock)
				where TenantId = @IndigoClientId
				and ParentQuestionId is not null
				and Ordinal is not null
			)
			update duplicates
			set Ordinal += 1 --nr
			where nr > 1
		if @@rowcount=0 break
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
