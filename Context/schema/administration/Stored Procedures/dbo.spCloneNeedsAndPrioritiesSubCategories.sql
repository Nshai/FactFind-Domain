SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCloneNeedsAndPrioritiesSubCategories] @IndigoClientId int, @SourceIndigoClientId int, @StampUser varchar(255) = '-1010'
as
begin
-- Administration > Organisation > Fact Find > Needs SubCategories
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
		-- TNeedsAndPrioritiesSubCategory
		update a
		set a.Ordinal = b.Ordinal,
			a.ConcurrencyId +=1
		output
			inserted.NeedsAndPrioritiesSubCategoryId, inserted.[Name], inserted.TenantId, inserted.Ordinal, inserted.ConcurrencyId
			,'U', @Now, @StampUser
		into administration.dbo.TNeedsAndPrioritiesSubCategoryAudit(NeedsAndPrioritiesSubCategoryId, [Name], TenantId, Ordinal, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from administration.dbo.TNeedsAndPrioritiesSubCategory a
			inner join administration.dbo.TNeedsAndPrioritiesSubCategory b on b.[Name] = a.[Name] and b.TenantId = @SourceIndigoClientId
		where a.TenantId = @IndigoClientId
			and isnull(a.Ordinal,0) != isnull(b.Ordinal,0)

		insert into administration.dbo.TNeedsAndPrioritiesSubCategory([Name], TenantId, Ordinal, ConcurrencyId)
		output
			inserted.NeedsAndPrioritiesSubCategoryId, inserted.[Name], inserted.TenantId, inserted.Ordinal, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into administration.dbo.TNeedsAndPrioritiesSubCategoryAudit(NeedsAndPrioritiesSubCategoryId, [Name], TenantId, Ordinal, ConcurrencyId
			, StampAction, StampDateTime, StampUser)

		select [Name], @IndigoClientId, Ordinal, 1
		from administration.dbo.TNeedsAndPrioritiesSubCategory
		where TenantId = @SourceIndigoClientId
		except
		select [Name], TenantId, Ordinal, 1
		from administration.dbo.TNeedsAndPrioritiesSubCategory
		where TenantId = @IndigoClientId

		-- TNeedsAndPrioritiesQuestion

		update a
		set a.Ordinal = b.Ordinal,
			a.ControlTypeId = b.ControlTypeId,
			a.IsArchived = b.IsArchived,
			a.IsForProfile = b.IsForProfile,
			a.IsTextArea = b.IsTextArea,
			a.RefPersonalCategoryId = b.RefPersonalCategoryId,
			a.RefCorporateCategoryId = b.RefCorporateCategoryId,
			a.NeedsAndPrioritiesSubCategoryId = d.NeedsAndPrioritiesSubCategoryId,
			a.ConcurrencyId+=1
		output
				inserted.NeedsAndPrioritiesQuestionId, inserted.Question, inserted.Ordinal, inserted.IsArchived, inserted.ConcurrencyId, inserted.TenantId, inserted.RefPersonalCategoryId, inserted.RefCorporateCategoryId
			, inserted.IsForProfile, inserted.IsTextArea, inserted.NeedsAndPrioritiesSubCategoryId, inserted.ControlTypeId
			,'U', @Now, @StampUser
		into Administration.dbo.TNeedsAndPrioritiesQuestionAudit(
				NeedsAndPrioritiesQuestionId, Question, Ordinal, IsArchived, ConcurrencyId, TenantId, RefPersonalCategoryId, RefCorporateCategoryId
			, IsForProfile, IsTextArea, NeedsAndPrioritiesSubCategoryId, ControlTypeId
			, StampAction, StampDateTime, StampUser)
		from Administration.dbo.TNeedsAndPrioritiesQuestion a
		inner join Administration.dbo.TNeedsAndPrioritiesQuestion b on b.Question = a.Question and b.TenantId = @SourceIndigoClientId
		left join administration.dbo.TNeedsAndPrioritiesSubCategory c on c.NeedsAndPrioritiesSubCategoryId = b.NeedsAndPrioritiesSubCategoryId and c.TenantId = @SourceIndigoClientId
		left join administration.dbo.TNeedsAndPrioritiesSubCategory d on d.[Name] = c.[Name] and d.TenantId = @IndigoClientId
		where a.TenantId = @IndigoClientId
			and (
				a.Ordinal != b.Ordinal
				or a.ControlTypeId != b.ControlTypeId
				or a.IsArchived != b.IsArchived
				or a.IsForProfile != b.IsForProfile
				or a.IsTextArea != b.IsTextArea
				or isnull(a.RefPersonalCategoryId,0) != isnull(b.RefPersonalCategoryId,0)
				or isnull(a.RefCorporateCategoryId,0) != isnull(b.RefCorporateCategoryId,0)
				or isnull(a.NeedsAndPrioritiesSubCategoryId,0) != isnull(d.NeedsAndPrioritiesSubCategoryId,0)
			)


		insert into Administration.dbo.TNeedsAndPrioritiesQuestion(Question, Ordinal, IsArchived, ConcurrencyId, TenantId, RefPersonalCategoryId, RefCorporateCategoryId, IsForProfile, IsTextArea, NeedsAndPrioritiesSubCategoryId, ControlTypeId)
		output
				inserted.NeedsAndPrioritiesQuestionId, inserted.Question, inserted.Ordinal, inserted.IsArchived, inserted.ConcurrencyId, inserted.TenantId, inserted.RefPersonalCategoryId, inserted.RefCorporateCategoryId
			, inserted.IsForProfile, inserted.IsTextArea, inserted.NeedsAndPrioritiesSubCategoryId, inserted.ControlTypeId
			,'C', @Now, @StampUser
		into Administration.dbo.TNeedsAndPrioritiesQuestionAudit(
				NeedsAndPrioritiesQuestionId, Question, Ordinal, IsArchived, ConcurrencyId, TenantId, RefPersonalCategoryId, RefCorporateCategoryId
			, IsForProfile, IsTextArea, NeedsAndPrioritiesSubCategoryId, ControlTypeId
			, StampAction, StampDateTime, StampUser)
		select Question, src.Ordinal, IsArchived, 1, @IndigoClientId, RefPersonalCategoryId, RefCorporateCategoryId, IsForProfile, IsTextArea, d.NeedsAndPrioritiesSubCategoryId, ControlTypeId
		from Administration.dbo.TNeedsAndPrioritiesQuestion src
			left join administration.dbo.TNeedsAndPrioritiesSubCategory c on c.NeedsAndPrioritiesSubCategoryId = src.NeedsAndPrioritiesSubCategoryId and c.TenantId = @SourceIndigoClientId
			left join administration.dbo.TNeedsAndPrioritiesSubCategory d on d.[Name] = c.[Name] and d.TenantId = @IndigoClientId
		where src.TenantId = @SourceIndigoClientId
		except
		select Question, Ordinal, IsArchived, 1, TenantId, RefPersonalCategoryId, RefCorporateCategoryId, IsForProfile, IsTextArea, NeedsAndPrioritiesSubCategoryId, ControlTypeId
		from Administration.dbo.TNeedsAndPrioritiesQuestion
		where TenantId = @IndigoClientId

		--
		update a
		set a.Ordinal = b.Ordinal,
			a.IsArchived = b.IsArchived,
			a.ConcurrencyId+=1
		output
			inserted.NeedsAndPrioritiesQuestionAnswerId, inserted.NeedsAndPrioritiesQuestionId, inserted.Answer, inserted.Ordinal, inserted.IsArchived, inserted.ConcurrencyId
			,'U', @Now, @StampUser
		into Administration.dbo.TNeedsAndPrioritiesQuestionAnswerAudit(
			NeedsAndPrioritiesQuestionAnswerId, NeedsAndPrioritiesQuestionId, Answer, Ordinal, IsArchived, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from Administration.dbo.TNeedsAndPrioritiesQuestionAnswer a
			inner join Administration.dbo.TNeedsAndPrioritiesQuestion qa on qa.NeedsAndPrioritiesQuestionId = a.NeedsAndPrioritiesQuestionId
			inner join Administration.dbo.TNeedsAndPrioritiesQuestion qas on qas.Question = qa.Question and qas.TenantId = @SourceIndigoClientId
			inner join Administration.dbo.TNeedsAndPrioritiesQuestionAnswer b on b.Answer = a.Answer and b.NeedsAndPrioritiesQuestionId = qas.NeedsAndPrioritiesQuestionId
		where qa.TenantId = @IndigoClientId
		and (
			a.Ordinal != b.Ordinal
			or a.IsArchived != b.IsArchived
		)


		insert into Administration.dbo.TNeedsAndPrioritiesQuestionAnswer(NeedsAndPrioritiesQuestionId, Answer, Ordinal, IsArchived, ConcurrencyId)
		output
			inserted.NeedsAndPrioritiesQuestionAnswerId, inserted.NeedsAndPrioritiesQuestionId, inserted.Answer, inserted.Ordinal, inserted.IsArchived, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into Administration.dbo.TNeedsAndPrioritiesQuestionAnswerAudit(
			NeedsAndPrioritiesQuestionAnswerId, NeedsAndPrioritiesQuestionId, Answer, Ordinal, IsArchived, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select qat.NeedsAndPrioritiesQuestionId, b.Answer, b.Ordinal, b.IsArchived, 1
		from Administration.dbo.TNeedsAndPrioritiesQuestion qat
			inner join Administration.dbo.TNeedsAndPrioritiesQuestion qas on qas.Question = qat.Question and qas.TenantId = @SourceIndigoClientId
			inner join Administration.dbo.TNeedsAndPrioritiesQuestionAnswer b on b.NeedsAndPrioritiesQuestionId = qas.NeedsAndPrioritiesQuestionId
		where qat.TenantId = @IndigoClientId
		except
		select a.NeedsAndPrioritiesQuestionId, a.Answer, a.Ordinal, a.IsArchived, 1
		from Administration.dbo.TNeedsAndPrioritiesQuestionAnswer a
			inner join Administration.dbo.TNeedsAndPrioritiesQuestion qa on qa.NeedsAndPrioritiesQuestionId = a.NeedsAndPrioritiesQuestionId
		where qa.TenantId = @IndigoClientId


		update a
			set a.IsArchived = b.IsArchived,
				a.ConcurrencyId+=1
		output
			inserted.DocumentDisclosureTypeId, inserted.ConcurrencyId, inserted.[Name], inserted.IsArchived, inserted.IndigoClientId
			,'U', @Now, @StampUser
		into FactFind.dbo.TDocumentDisclosureTypeAudit(
			DocumentDisclosureTypeId, ConcurrencyId, [Name], IsArchived, IndigoClientId
			, StampAction, StampDateTime, StampUser)
		from FactFind.dbo.TDocumentDisclosureType a
			inner join FactFind.dbo.TDocumentDisclosureType b on b.[Name] = a.[Name] and b.IndigoClientId = @SourceIndigoClientId
		where a.IndigoClientId = @IndigoClientId
			and a.IsArchived != b.IsArchived

		insert into FactFind.dbo.TDocumentDisclosureType([Name], IsArchived, IndigoClientId, ConcurrencyId)
		output
			inserted.DocumentDisclosureTypeId, inserted.ConcurrencyId, inserted.[Name], inserted.IsArchived, inserted.IndigoClientId
			,'C', @Now, @StampUser
		into FactFind.dbo.TDocumentDisclosureTypeAudit(
			DocumentDisclosureTypeId, ConcurrencyId, [Name], IsArchived, IndigoClientId
			, StampAction, StampDateTime, StampUser)
		select [Name], IsArchived, @IndigoClientId, 1
		from FactFind.dbo.TDocumentDisclosureType
		where IndigoClientId = @SourceIndigoClientId
		except
		select [Name], IsArchived, IndigoClientId, 1
		from FactFind.dbo.TDocumentDisclosureType
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
