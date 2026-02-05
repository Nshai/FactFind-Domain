SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCloneIncomeMatchingConfiguration] @IndigoClientId int, @SourceIndigoClientId int, @StampUser varchar(255) = '-1010'
as
begin
-- Automatching Configuration
-- Income > Administration > Income Matching Configuration
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
		/*
		PMUseLookupFG - Use Lookups for Policy Matching
		AutoMatchStatements - Auto-Match Cash Receipts to Provider Statements
		AutoMatchFees - Auto-Match Cash Receipts to Fees
		AutoMatchRetainers - Auto-Match Cash Receipts to Retainers
		AutoMatchRetainersBySeqRef - Auto-Match Cash Receipts to Retainers with IOR Number in Cash Receipt Description Field
		AgencyNumberMatching - Use Agency Number for Policy Matching
		AutoMatchFeesBySeqRef - Auto-Match Cash Receipts to Fees with IOF Number in Cash Receipt Description Field
		AutoMatchInvoicesBySeqRef - Auto-Match Cash Receipts to Invoices with IOI Number in Cash Receipt Description Field
		HideOrganisationFigures - Hide Organisation Split from Expected Payments action under plan
		MinBACSAmount - Minimum BACS amount

		-- Plan Allocation & Fee Linking Configuration
		InitialTopupAutoMatchingBehaviour
		RecurringTopupAutoMatchingBehaviour
		TerminatePlanAllocationIfNoFeeLinkedInitialAndAdHoc
		TerminatePlanAllocationIfNoFeeLinkedRecurring

		-- Fee Tolerance Configuration
		FeeToleranceBehaviour
		FeeTolerance
		*/

		update a
		set
			a.PMUseLookupFG = b.PMUseLookupFG,
			a.AutoMatchStatements = b.AutoMatchStatements,
			a.AutoMatchFees = b.AutoMatchFees,
			a.AutoMatchFeesBySeqRef = b.AutoMatchFeesBySeqRef,
			a.AutoMatchRetainers = b.AutoMatchRetainers,
			a.AutoMatchRetainersBySeqRef = b.AutoMatchRetainersBySeqRef,
			a.AutoMatchInvoicesBySeqRef = b.AutoMatchInvoicesBySeqRef,
			a.AgencyNumberMatching = b.AgencyNumberMatching,
			a.HideOrganisationFigures = b.HideOrganisationFigures,
			a.MinBACSAmount = b.MinBACSAmount,
			a.InitialTopupAutoMatchingBehaviour = b.InitialTopupAutoMatchingBehaviour,
			a.RecurringTopupAutoMatchingBehaviour = b.RecurringTopupAutoMatchingBehaviour,
			a.TerminatePlanAllocationIfNoFeeLinkedInitialAndAdHoc = b.TerminatePlanAllocationIfNoFeeLinkedInitialAndAdHoc,
			a.TerminatePlanAllocationIfNoFeeLinkedRecurring = b.TerminatePlanAllocationIfNoFeeLinkedRecurring,
			a.FeeToleranceBehaviour = b.FeeToleranceBehaviour,
			a.FeeTolerance = b.FeeTolerance,
			a.ConcurrencyId +=1
		output
			inserted.DefaultId,
			inserted.IndigoClientId,
			inserted.AllowClawbackFG,
			inserted.PreventDeallocationAfterPaymentRun,
			inserted.OnlyAllocateWhenMatchedToCash,
			inserted.OpenStatementAsAdmin,
			inserted.OptimiseCashMatchAtomicity,
			inserted.DateOrder,
			inserted.PayCurrentGroupFG,
			inserted.RecalcIntroducerSplitFG,
			inserted.RecalcPractPercentFG,
			inserted.DefaultPayeeEntityId,
			inserted.HideOrganisationFigures,
			inserted.PMMaxDiffAmount,
			inserted.PMUseLinkProviderFG,
			inserted.PMUseLookupFG,
			inserted.PMMatchSurnameFirstFG,
			inserted.PMMatchSurnameLastFG,
			inserted.PMMatchCompanyNameFG,
			inserted.PMMatchSurnameFirstWithAgencyCodeFG,
			inserted.PMMatchSurnameLastWithAgencyCodeFG,
			inserted.PMMatchCompanyNameWithAgencyCodeFG,
			inserted.AdviserAgencyLookupFG,
			inserted.CMUseLinkProviderFG,
			inserted.CMProvDescLength,
			inserted.CMDateRangeUpper,
			inserted.CMDateRangeLower,
			inserted.MinBACSAmount,
			inserted.AllowAutoMatch,
			inserted.AutoMatchStatements,
			inserted.AutoMatchFees,
			inserted.AutoMatchRetainers,
			inserted.AutoMatchRetainersBySeqRef,
			inserted.AmountChecksForPasses,
			inserted.ClientNameMatchingWithBlankPolicyNo,
			inserted.RenewalPlanMatching,
			inserted.AgencyNumberMatching,
			inserted.ConcurrencyId,
			inserted.AutoMatchFeesBySeqRef,
			inserted.AutoMatchInvoicesBySeqRef,
			inserted.TerminatePlanAllocationIfNoFeeLinkedInitialAndAdHoc,
			inserted.TerminatePlanAllocationIfNoFeeLinkedRecurring,
			inserted.InitialTopupAutoMatchingBehaviour,
			inserted.RecurringTopupAutoMatchingBehaviour,
			inserted.FeeToleranceBehaviour,
			inserted.FeeTolerance
			,'U', @Now, @StampUser
		into commissions.dbo.TDefaultAudit(
			DefaultId,
			IndigoClientId,
			AllowClawbackFG,
			PreventDeallocationAfterPaymentRun,
			OnlyAllocateWhenMatchedToCash,
			OpenStatementAsAdmin,
			OptimiseCashMatchAtomicity,
			DateOrder,
			PayCurrentGroupFG,
			RecalcIntroducerSplitFG,
			RecalcPractPercentFG,
			DefaultPayeeEntityId,
			HideOrganisationFigures,
			PMMaxDiffAmount,
			PMUseLinkProviderFG,
			PMUseLookupFG,
			PMMatchSurnameFirstFG,
			PMMatchSurnameLastFG,
			PMMatchCompanyNameFG,
			PMMatchSurnameFirstWithAgencyCodeFG,
			PMMatchSurnameLastWithAgencyCodeFG,
			PMMatchCompanyNameWithAgencyCodeFG,
			AdviserAgencyLookupFG,
			CMUseLinkProviderFG,
			CMProvDescLength,
			CMDateRangeUpper,
			CMDateRangeLower,
			MinBACSAmount,
			AllowAutoMatch,
			AutoMatchStatements,
			AutoMatchFees,
			AutoMatchRetainers,
			AutoMatchRetainersBySeqRef,
			AmountChecksForPasses,
			ClientNameMatchingWithBlankPolicyNo,
			RenewalPlanMatching,
			AgencyNumberMatching,
			ConcurrencyId,
			AutoMatchFeesBySeqRef,
			AutoMatchInvoicesBySeqRef,
			TerminatePlanAllocationIfNoFeeLinkedInitialAndAdHoc,
			TerminatePlanAllocationIfNoFeeLinkedRecurring,
			InitialTopupAutoMatchingBehaviour,
			RecurringTopupAutoMatchingBehaviour,
			FeeToleranceBehaviour,
			FeeTolerance
			, StampAction, StampDateTime, StampUser)
		from commissions.dbo.TDefault	a, commissions.dbo.TDefault	b
		where a.IndigoClientId = @IndigoClientId
			and b.IndigoClientId = @SourceIndigoClientId
			--and (a.PMUseLookupFG != b.PMUseLookupFG
			--	or a.AutoMatchStatements != b.AutoMatchStatements
			--	or a.AutoMatchFees != b.AutoMatchFees
			--	or a.AutoMatchRetainers != b.AutoMatchRetainers
			--	or a.AutoMatchRetainersBySeqRef != b.AutoMatchRetainersBySeqRef
			--	or a.AgencyNumberMatching != b.AgencyNumberMatching
			--	or a.AutoMatchFeesBySeqRef != b.AutoMatchFeesBySeqRef
			--	or a.AutoMatchInvoicesBySeqRef != b.AutoMatchInvoicesBySeqRef
			--	)

		if @@rowcount=0 begin
			insert into commissions.dbo.TDefault(
				IndigoClientId,
				AllowClawbackFG,
				PreventDeallocationAfterPaymentRun,
				OnlyAllocateWhenMatchedToCash,
				OpenStatementAsAdmin,
				OptimiseCashMatchAtomicity,
				DateOrder,
				PayCurrentGroupFG,
				RecalcIntroducerSplitFG,
				RecalcPractPercentFG,
				DefaultPayeeEntityId,
				HideOrganisationFigures,
				PMMaxDiffAmount,
				PMUseLinkProviderFG,
				PMUseLookupFG,
				PMMatchSurnameFirstFG,
				PMMatchSurnameLastFG,
				PMMatchCompanyNameFG,
				PMMatchSurnameFirstWithAgencyCodeFG,
				PMMatchSurnameLastWithAgencyCodeFG,
				PMMatchCompanyNameWithAgencyCodeFG,
				AdviserAgencyLookupFG,
				CMUseLinkProviderFG,
				CMProvDescLength,
				CMDateRangeUpper,
				CMDateRangeLower,
				MinBACSAmount,
				AllowAutoMatch,
				AutoMatchStatements,
				AutoMatchFees,
				AutoMatchRetainers,
				AutoMatchRetainersBySeqRef,
				AmountChecksForPasses,
				ClientNameMatchingWithBlankPolicyNo,
				RenewalPlanMatching,
				AgencyNumberMatching,
				ConcurrencyId,
				AutoMatchFeesBySeqRef,
				AutoMatchInvoicesBySeqRef,
				TerminatePlanAllocationIfNoFeeLinkedInitialAndAdHoc,
				TerminatePlanAllocationIfNoFeeLinkedRecurring,
				InitialTopupAutoMatchingBehaviour,
				RecurringTopupAutoMatchingBehaviour,
				FeeToleranceBehaviour,
				FeeTolerance)
			output
				inserted.DefaultId,
				inserted.IndigoClientId,
				inserted.AllowClawbackFG,
				inserted.PreventDeallocationAfterPaymentRun,
				inserted.OnlyAllocateWhenMatchedToCash,
				inserted.OpenStatementAsAdmin,
				inserted.OptimiseCashMatchAtomicity,
				inserted.DateOrder,
				inserted.PayCurrentGroupFG,
				inserted.RecalcIntroducerSplitFG,
				inserted.RecalcPractPercentFG,
				inserted.DefaultPayeeEntityId,
				inserted.HideOrganisationFigures,
				inserted.PMMaxDiffAmount,
				inserted.PMUseLinkProviderFG,
				inserted.PMUseLookupFG,
				inserted.PMMatchSurnameFirstFG,
				inserted.PMMatchSurnameLastFG,
				inserted.PMMatchCompanyNameFG,
				inserted.PMMatchSurnameFirstWithAgencyCodeFG,
				inserted.PMMatchSurnameLastWithAgencyCodeFG,
				inserted.PMMatchCompanyNameWithAgencyCodeFG,
				inserted.AdviserAgencyLookupFG,
				inserted.CMUseLinkProviderFG,
				inserted.CMProvDescLength,
				inserted.CMDateRangeUpper,
				inserted.CMDateRangeLower,
				inserted.MinBACSAmount,
				inserted.AllowAutoMatch,
				inserted.AutoMatchStatements,
				inserted.AutoMatchFees,
				inserted.AutoMatchRetainers,
				inserted.AutoMatchRetainersBySeqRef,
				inserted.AmountChecksForPasses,
				inserted.ClientNameMatchingWithBlankPolicyNo,
				inserted.RenewalPlanMatching,
				inserted.AgencyNumberMatching,
				inserted.ConcurrencyId,
				inserted.AutoMatchFeesBySeqRef,
				inserted.AutoMatchInvoicesBySeqRef,
				inserted.TerminatePlanAllocationIfNoFeeLinkedInitialAndAdHoc,
				inserted.TerminatePlanAllocationIfNoFeeLinkedRecurring,
				inserted.InitialTopupAutoMatchingBehaviour,
				inserted.RecurringTopupAutoMatchingBehaviour,
				inserted.FeeToleranceBehaviour,
				inserted.FeeTolerance
				,'C', @Now, @StampUser
			into commissions.dbo.TDefaultAudit(
				DefaultId,
				IndigoClientId,
				AllowClawbackFG,
				PreventDeallocationAfterPaymentRun,
				OnlyAllocateWhenMatchedToCash,
				OpenStatementAsAdmin,
				OptimiseCashMatchAtomicity,
				DateOrder,
				PayCurrentGroupFG,
				RecalcIntroducerSplitFG,
				RecalcPractPercentFG,
				DefaultPayeeEntityId,
				HideOrganisationFigures,
				PMMaxDiffAmount,
				PMUseLinkProviderFG,
				PMUseLookupFG,
				PMMatchSurnameFirstFG,
				PMMatchSurnameLastFG,
				PMMatchCompanyNameFG,
				PMMatchSurnameFirstWithAgencyCodeFG,
				PMMatchSurnameLastWithAgencyCodeFG,
				PMMatchCompanyNameWithAgencyCodeFG,
				AdviserAgencyLookupFG,
				CMUseLinkProviderFG,
				CMProvDescLength,
				CMDateRangeUpper,
				CMDateRangeLower,
				MinBACSAmount,
				AllowAutoMatch,
				AutoMatchStatements,
				AutoMatchFees,
				AutoMatchRetainers,
				AutoMatchRetainersBySeqRef,
				AmountChecksForPasses,
				ClientNameMatchingWithBlankPolicyNo,
				RenewalPlanMatching,
				AgencyNumberMatching,
				ConcurrencyId,
				AutoMatchFeesBySeqRef,
				AutoMatchInvoicesBySeqRef,
				TerminatePlanAllocationIfNoFeeLinkedInitialAndAdHoc,
				TerminatePlanAllocationIfNoFeeLinkedRecurring,
				InitialTopupAutoMatchingBehaviour,
				RecurringTopupAutoMatchingBehaviour,
				FeeToleranceBehaviour,
				FeeTolerance
				, StampAction, StampDateTime, StampUser)
			select
				@IndigoClientId,
				AllowClawbackFG,
				PreventDeallocationAfterPaymentRun,
				OnlyAllocateWhenMatchedToCash,
				OpenStatementAsAdmin,
				OptimiseCashMatchAtomicity,
				DateOrder,
				PayCurrentGroupFG,
				RecalcIntroducerSplitFG,
				RecalcPractPercentFG,
				DefaultPayeeEntityId,
				HideOrganisationFigures,
				PMMaxDiffAmount,
				PMUseLinkProviderFG,
				PMUseLookupFG,
				PMMatchSurnameFirstFG,
				PMMatchSurnameLastFG,
				PMMatchCompanyNameFG,
				PMMatchSurnameFirstWithAgencyCodeFG,
				PMMatchSurnameLastWithAgencyCodeFG,
				PMMatchCompanyNameWithAgencyCodeFG,
				AdviserAgencyLookupFG,
				CMUseLinkProviderFG,
				CMProvDescLength,
				CMDateRangeUpper,
				CMDateRangeLower,
				MinBACSAmount,
				AllowAutoMatch,
				AutoMatchStatements,
				AutoMatchFees,
				AutoMatchRetainers,
				AutoMatchRetainersBySeqRef,
				AmountChecksForPasses,
				ClientNameMatchingWithBlankPolicyNo,
				RenewalPlanMatching,
				AgencyNumberMatching,
				1, --ConcurrencyId,
				AutoMatchFeesBySeqRef,
				AutoMatchInvoicesBySeqRef,
				TerminatePlanAllocationIfNoFeeLinkedInitialAndAdHoc,
				TerminatePlanAllocationIfNoFeeLinkedRecurring,
				InitialTopupAutoMatchingBehaviour,
				RecurringTopupAutoMatchingBehaviour,
				FeeToleranceBehaviour,
				FeeTolerance
			from commissions.dbo.TDefault
			where IndigoClientId = @SourceIndigoClientId

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
