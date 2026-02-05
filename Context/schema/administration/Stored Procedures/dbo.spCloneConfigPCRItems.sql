SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCloneConfigPCRItems] @IndigoClientId int, @SourceIndigoClientId int, @RegionCode nvarchar(max) null, @StampUser varchar(255) = '-1010'
as
begin

	raiserror('Clone settings from SourceIndigoClient...',0,1) with nowait

	Set nocount on
	declare
		@NumRecs int,
		@msg varchar(max)

	if @SourceIndigoClientId is null or @IndigoClientId is null return

	if not exists(select 1 from Administration..TIndigoClient where IndigoClientId = @SourceIndigoClientId) return
	if not exists(select 1 from Administration..TIndigoClient where IndigoClientId = @IndigoClientId) return

	select @NumRecs = count(1) from Administration..TGroup where IndigoClientId = @IndigoClientId and ParentId is null
	if @NumRecs>1 begin
		set @msg = 'Destination tenant has '+convert(varchar(10), @NumRecs)+' top tier groups! (groups without ParentId)
Only one is allowed. PLEASE FIX THE DATA!
-----------------------------------------'
		RAISERROR(@msg, 16, 1)
		RETURN
	end

	-- Standby: This will be called after the user/adviser creation
	--exec dbo.spCloneAdviserGating @IndigoClientId

	-- Grouping, Group, Role, Corporate and corresponding Contact

	exec dbo.spCloneHierarchy @IndigoClientId, @SourceIndigoClientId, @StampUser -- Required for Campaign
	if @@Error!=0 return
	exec dbo.spCloneDashboard @IndigoClientId, @SourceIndigoClientId, @StampUser
	if @@Error!=0 return
	exec dbo.spCloneOpportunityTypeAndStatus @IndigoClientId, @SourceIndigoClientId, @RegionCode, @StampUser
	if @@Error!=0 return
	exec dbo.spCloneDuplicateClientSettings @IndigoClientId, @SourceIndigoClientId, @StampUser
	if @@Error!=0 return
	exec dbo.spCloneLeadInterestAndStatus @IndigoClientId, @SourceIndigoClientId, @StampUser
	if @@Error!=0 return
	exec dbo.spCloneActivityOutcomes @IndigoClientId, @SourceIndigoClientId, @StampUser
	if @@Error!=0 return
	exec dbo.spCloneNeedsAndPrioritiesSubCategories @IndigoClientId, @SourceIndigoClientId, @StampUser
	if @@Error!=0 return
	exec dbo.spCloneChecklistCategoriesAndQuestions @IndigoClientId, @SourceIndigoClientId, @StampUser
	if @@Error!=0 return
	exec dbo.spCloneDocumentStatusTransitions @IndigoClientId, @SourceIndigoClientId, @StampUser
	if @@Error!=0 return
	exec dbo.spCloneDocumentBinderTransitions @IndigoClientId, @SourceIndigoClientId, @StampUser
	if @@Error!=0 return
	exec dbo.spCloneDocumentDeleteRights @IndigoClientId, @SourceIndigoClientId, @StampUser
	if @@Error!=0 return
	exec dbo.spCloneServiceCase @IndigoClientId, @SourceIndigoClientId, @StampUser
	if @@Error!=0 return
	exec dbo.spCloneAdviserCharging @IndigoClientId, @SourceIndigoClientId, @StampUser
	if @@Error!=0 return
	exec dbo.spCloneIncomeMatchingConfiguration @IndigoClientId, @SourceIndigoClientId, @StampUser
	if @@Error!=0 return
	exec dbo.spCloneFeesAndRetainers @IndigoClientId, @SourceIndigoClientId, @StampUser
	if @@Error!=0 return
	exec dbo.spClonePlanPurpose @IndigoClientId, @SourceIndigoClientId, @StampUser
	if @@Error!=0 return
	exec dbo.spCloneLifeCyclePlans @IndigoClientId, @SourceIndigoClientId, @StampUser
	if @@Error!=0 return
	exec dbo.spCloneFeeModelToServiceCase @IndigoClientId, @SourceIndigoClientId, @StampUser
	if @@Error!=0 return
	exec dbo.spCloneLifeCycleRules @IndigoClientId, @SourceIndigoClientId, @StampUser
	if @@Error!=0 return
	exec dbo.spCloneRefExpenditureGroup @IndigoClientId, @SourceIndigoClientId, @RegionCode, @StampUser -- DM-3351 & DEF-5515

end
GO
