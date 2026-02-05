SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--sp_helptext spNCustomCreateFinancialPlanningAssetGraphDetail

--exec spNCustomCreateFinancialPlanningAssetGraphDetail @FinancialPlanningId=30,@Data=N'<data seriesColors="#7751516;#7A5F9A;#B3A8C4;"><row identifier="Original" Cash="5.57" Property="0" FixedInterest="79.80" UKEquity="0" OverseasEquity="14.62" SpecialistEquity ="0" /><row identifier="Revised" Cash="5.72" Property="0" FixedInterest="75.16" UKEquity="0" OverseasEquity="19.12" SpecialistEquity ="0" /><row identifier="Target" Cash="7.870485952733559463013819200" Property="0" FixedInterest="7.2529884190041231913149043600" UKEquity="0" OverseasEquity="84.87652562826231734567127644" SpecialistEquity ="0" /></data>',@UserId=N'14120'
CREATE procedure [dbo].[spNCustomCreateFinancialPlanningAssetGraphDetail]
@FinancialPlanningId bigint,
@Data varchar(Max),
@UserId bigint

as

declare @id bigint

if exists (select 1 from TFinancialPlanningAssetGraphDetail where FinancialPlanningId = @FinancialPlanningId) begin

	insert into TFinancialPlanningAssetGraphDetailAudit
	(FinancialPlanningId,
	Data,
	ConcurrencyId,
	FinancialPlanningAssetGraphDetailId,
	STAMPACTION,
	STAMPDATETIME,
	STAMPUSER)
	select	
	FinancialPlanningId,
	Data,
	ConcurrencyId,
	FinancialPlanningAssetGraphDetailId,
	'U',
	getdate(),
	@UserId
	from TFinancialPlanningAssetGraphDetail	
	where FinancialPlanningId = @FinancialPlanningId

	update	TFinancialPlanningAssetGraphDetail
	set	Data = @Data,
		ConcurrencyId = ConcurrencyId +1
	where FinancialPlanningId = @FinancialPlanningId

end
else begin

	insert into TFinancialPlanningAssetGraphDetail
	(
	FinancialPlanningId,
	Data,
	ConcurrencyId
	)
	select	@FinancialPlanningId,
			@Data,
			1

	select @id = scope_identity()

	insert into TFinancialPlanningAssetGraphDetailAudit
	(FinancialPlanningId,
	Data,
	ConcurrencyId,
	FinancialPlanningAssetGraphDetailId,
	STAMPACTION,
	STAMPDATETIME,
	STAMPUSER)
	select	
	FinancialPlanningId,
	Data,
	ConcurrencyId,
	FinancialPlanningAssetGraphDetailId,
	'C',
	getdate(),
	@UserId
	from TFinancialPlanningAssetGraphDetail	
	where FinancialPlanningAssetGraphDetailId = @id

end




GO
