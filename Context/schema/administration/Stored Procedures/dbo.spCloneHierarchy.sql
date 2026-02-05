SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCloneHierarchy] @IndigoClientId int, @SourceIndigoClientId int, @StampUser varchar(255) = '-1010'
as
begin
	set nocount on
	declare @ProcName sysname = OBJECT_NAME(@@PROCID),
		@procResult int
	exec @procResult = dbo.spStartCreateTenantModule @IndigoClientId, @SourceIndigoClientId, @ProcName
	if @procResult!=0 return

	declare @tx int,
		@Now datetime = GetDate(),
		@tableName sysname = '',
		@msg varchar(max)

	select @tx = @@TRANCOUNT

	if @tx = 0 begin
		set @msg=@ProcName+': begin transaction TX'
		raiserror(@msg,0,1) with nowait
		begin transaction TX
	end

	begin try

		/*****************************************************************
		This code is based on DataImportIOtoIO, used for L&G and NBS
		*****************************************************************/

		declare @IO_MigrationRef varchar(max) ='',
			@SourceContactId int,
			@IO_ID_FK_ContactId int

		-- Get source Tenant's ContactId
		select @SourceContactId = ContactId
		from Administration.dbo.TIndigoClient
		where IndigoClientId = @SourceIndigoClientId

		-- Get target Tenant's ContactId
		select @IO_ID_FK_ContactId = ContactId
		from Administration.dbo.TIndigoClient
		where IndigoClientId = @IndigoClientId

		if object_id('tempdb..#InsertOutput') is not null drop table #InsertOutput
		create table #InsertOutput (IO_MIgrationRef varchar(max), TheNewId int NOT NULL)

		if object_id('tempdb..#Grouping_Extract_IO') is not null drop table #Grouping_Extract_IO -- SEL/IMP/AUD/CASC group + role
		if object_id('tempdb..#CrmContact_Extract_IO') is not null drop table #CrmContact_Extract_IO -- SEL/IMP/AUD/CASC group
		if object_id('tempdb..#Corporate_Extract_IO') is not null drop table #Corporate_Extract_IO -- SEL/IMP/AUD/CASC CrmContact
		if object_id('tempdb..#Role_Extract_IO') is not null drop table #Role_Extract_IO -- SEL/IMP/AUD
		if object_id('tempdb..#Group_Extract_IO') is not null drop table #Group_Extract_IO -- SEL/IMP/AUD
		if object_id('tempdb..#CampaignType_Extract_IO') is not null drop table #CampaignType_Extract_IO
		if object_id('tempdb..#Campaign_Extract_IO') is not null drop table #Campaign_Extract_IO
		if object_id('tempdb..#CampaignChannel_Extract_IO') is not null drop table #CampaignChannel_Extract_IO
		--if object_id('tempdb..#CampaignData_Extract_IO') is not null drop table #CampaignData_Extract_IO


		--- *************************************
		--- START EXTRACTION

		-- CAMPAIGN related stuff

		-- TCampaignType
		set @tableName = 'TCampaignType'
		set @msg='Extract '+@tableName
		raiserror(@msg,0,1) with nowait

		select * into #CampaignType_Extract_IO
		from crm.dbo.TCampaignType
		where IndigoClientId = @SourceIndigoClientId

		alter table #CampaignType_Extract_IO add IO_ID_CampaignTypeId int
		alter table #CampaignType_Extract_IO add IO_ID_FK_IndigoClientId int
		alter table #CampaignType_Extract_IO add IO_ID_Status varchar(100)
		alter table #CampaignType_Extract_IO add IO_MigrationRef varchar(100)

		create index #CampaignType_Extract_IO_PK on #CampaignType_Extract_IO(CampaignTypeId)
		create index #CampaignType_Extract_IO_ID_IDX on #CampaignType_Extract_IO(IO_ID_CampaignTypeId)

		update #CampaignType_Extract_IO
		set IO_ID_FK_IndigoClientId = @IndigoClientId,
			IO_MigrationRef = 'iO2iO:'+Convert(varchar(100), CampaignTypeId)

		-- TCampaign
		set @tableName = 'TCampaign'
		set @msg='Extract '+@tableName
		raiserror(@msg,0,1) with nowait

		select * into #Campaign_Extract_IO
		from crm.dbo.TCampaign
		where IndigoClientId = @SourceIndigoClientId

		alter table #Campaign_Extract_IO add IO_ID_CampaignId int
		alter table #Campaign_Extract_IO add IO_ID_FK_CampaignTypeId int
		alter table #Campaign_Extract_IO add IO_ID_FK_IndigoClientId int
		alter table #Campaign_Extract_IO add IO_ID_FK_GroupId int
		alter table #Campaign_Extract_IO add IO_ID_Status varchar(100)
		alter table #Campaign_Extract_IO add IO_MigrationRef varchar(100)

		create index #Campaign_Extract_IO_PK on #Campaign_Extract_IO(CampaignId)
		create index #Campaign_Extract_IO_ID_IDX on #Campaign_Extract_IO(IO_ID_CampaignId)

		update #Campaign_Extract_IO
		set IO_ID_FK_IndigoClientId = @IndigoClientId,
			IO_MigrationRef = 'iO2iO:'+Convert(varchar(100), CampaignId)


		-- TCampaignChannel
		set @tableName = 'TCampaignChannel'
		set @msg='Extract '+@tableName
		raiserror(@msg,0,1) with nowait

		select * into #CampaignChannel_Extract_IO
		from crm.dbo.TCampaignChannel
		where IndigoClientId = @SourceIndigoClientId

		alter table #CampaignChannel_Extract_IO add IO_ID_CampaignChannelId int
		alter table #CampaignChannel_Extract_IO add IO_ID_FK_IndigoClientId int
		alter table #CampaignChannel_Extract_IO add IO_ID_Status varchar(100)
		alter table #CampaignChannel_Extract_IO add IO_MigrationRef varchar(100)

		create index #CampaignChannel_Extract_IO_PK on #CampaignChannel_Extract_IO(CampaignChannelId)
		create index #CampaignChannel_Extract_IO_ID_IDX on #CampaignChannel_Extract_IO(IO_ID_CampaignChannelId)

		update #CampaignChannel_Extract_IO
		set IO_ID_FK_IndigoClientId = @IndigoClientId,
			IO_MigrationRef = 'iO2iO:'+Convert(varchar(100), CampaignChannelId)

		-- TGrouping
		set @tableName = 'TGrouping'
		set @msg='Extract '+@tableName
		raiserror(@msg,0,1) with nowait

		select * into #Grouping_Extract_IO
		from Administration.dbo.TGrouping
		where IndigoClientId = @SourceIndigoClientId

		alter table #Grouping_Extract_IO add IO_ID_GroupingId int
		alter table #Grouping_Extract_IO add IO_ID_FK_IndigoClientId int
		alter table #Grouping_Extract_IO add IO_ID_FK_ParentId int
		alter table #Grouping_Extract_IO add IO_ID_Status varchar(100)
		alter table #Grouping_Extract_IO add IO_MigrationRef varchar(100)

		create index #Grouping_Extract_IO_PK on #Grouping_Extract_IO(GroupingId)
		create index #Grouping_Extract_IO_ID_IDX on #Grouping_Extract_IO(IO_ID_GroupingId)

		update #Grouping_Extract_IO
		set IO_ID_FK_IndigoClientId = @IndigoClientId,
			IO_MigrationRef = 'iO2iO:'+Convert(varchar(100), GroupingId)


		-- TRole
		set @tableName = 'TRole'
		set @msg='Extract '+@tableName
		raiserror(@msg,0,1) with nowait

		select * into #Role_Extract_IO
		from Administration.dbo.TRole
		where IndigoClientId = @SourceIndigoClientId

		alter table #Role_Extract_IO add IO_ID_RoleId int
		alter table #Role_Extract_IO add IO_ID_FK_IndigoClientId int
		alter table #Role_Extract_IO add IO_ID_FK_RefLicenseTypeId int
		alter table #Role_Extract_IO add IO_ID_FK_GroupingId int
		alter table #Role_Extract_IO add IO_ID_Status varchar(100)
		alter table #Role_Extract_IO add IO_MigrationRef varchar(100)

		create index #Role_Extract_IO_PK on #Role_Extract_IO(RoleId)
		create index #Role_Extract_IO_ID_IDX on #Role_Extract_IO(IO_ID_RoleId)

		update #Role_Extract_IO
		set IO_ID_FK_IndigoClientId = @IndigoClientId,
			IO_ID_FK_RefLicenseTypeId = RefLicenseTypeId,
			IO_MigrationRef = 'iO2iO:'+Convert(varchar(100), RoleId)

		-- TGroup
		set @tableName = 'TGroup'
		set @msg='Extract '+@tableName
		raiserror(@msg,0,1) with nowait

		select * into #Group_Extract_IO
		from Administration.dbo.TGroup
		where IndigoClientId = @SourceIndigoClientId

		alter table #Group_Extract_IO add IO_ID_GroupId int
		alter table #Group_Extract_IO add IO_ID_FK_IndigoClientId int
		alter table #Group_Extract_IO add IO_ID_FK_CrmContactId int
		alter table #Group_Extract_IO add IO_ID_FK_ParentId int
		alter table #Group_Extract_IO add IO_ID_FK_GroupingId int
		alter table #Group_Extract_IO add IO_ID_Status varchar(100)
		alter table #Group_Extract_IO add IO_MigrationRef varchar(100)

		create index #Group_Extract_IO_PK on #Group_Extract_IO(GroupId)
		create index #Group_Extract_IO_ID_IDX on #Group_Extract_IO(IO_ID_GroupId)

		update #Group_Extract_IO
		set IO_ID_FK_IndigoClientId = @IndigoClientId,
			IO_MigrationRef = 'iO2iO:'+Convert(varchar(100), GroupId)

		-- TCrmContact
		set @tableName = 'TCRMContact'
		set @msg='Extract '+@tableName
		raiserror(@msg,0,1) with nowait

		select c.* into #CrmContact_Extract_IO
		from CRM.dbo.TCRMContact c
		inner join #Group_Extract_IO g on g.CRMContactId = c.CRMContactId

		alter table #CrmContact_Extract_IO add IO_ID_CRMContactId int
		alter table #CrmContact_Extract_IO add IO_ID_FK_RefCRMContactStatusId int
		alter table #CrmContact_Extract_IO add IO_ID_FK_IndClientId int
		alter table #CrmContact_Extract_IO add IO_ID_FK_ClientTypeId int
		alter table #CrmContact_Extract_IO add IO_ID_FK_CorporateId int
		alter table #CrmContact_Extract_IO add IO_ID_FK_PersonId int
		alter table #CrmContact_Extract_IO add IO_ID_FK_TrustId int
		alter table #CrmContact_Extract_IO add IO_ID_FK_RefSourceOfClientId int
		alter table #CrmContact_Extract_IO add IO_ID_FK_OriginalAdviserCRMId int
		alter table #CrmContact_Extract_IO add IO_ID_FK_CurrentAdviserCRMId int
		alter table #CrmContact_Extract_IO add IO_ID_FK_FactFindId int
		alter table #CrmContact_Extract_IO add IO_ID_FK_RefServiceStatusId int
		alter table #CrmContact_Extract_IO add IO_ID_FK_CampaignDataId int
		alter table #CrmContact_Extract_IO add IO_ID_FK_AdviserAssignedByUserId int
		alter table #CrmContact_Extract_IO add IO_ID_FK__ParentId int
		alter table #CrmContact_Extract_IO add IO_ID_FK__OwnerId int
		alter table #CrmContact_Extract_IO add IO_ID_FK_FeeModelId int
		alter table #CrmContact_Extract_IO add IO_ID_Status varchar(100)
		alter table #CrmContact_Extract_IO add IO_MigrationRef varchar(100)

		create index #CrmContact_Extract_IO_PK on #CrmContact_Extract_IO(CrmContactId)
		create index #CrmContact_Extract_IO_ID_IDX on #CrmContact_Extract_IO(IO_ID_CrmContactId)

		update #CrmContact_Extract_IO
		set
			IO_ID_FK_IndClientId = @IndigoClientId,
			IO_MigrationRef = 'iO2iO:'+Convert(varchar(100), CrmContactId),
			IO_ID_FK_RefCRMContactStatusId = RefCRMContactStatusId,
			IO_ID_FK_RefSourceOfClientId = RefSourceOfClientId,
			IO_ID_FK_OriginalAdviserCRMId = OriginalAdviserCRMId,
			IO_ID_FK_CurrentAdviserCRMId = CurrentAdviserCRMId,

			IO_ID_FK_FactFindId = FactFindId, -- ALL NULL
			IO_ID_FK_RefServiceStatusId = RefServiceStatusId,
			IO_ID_FK_AdviserAssignedByUserId = AdviserAssignedByUserId,
			--IO_ID_FK__ParentId = _ParentId, -- ALL NULL
			IO_ID_FK_FeeModelId = FeeModelId,
			IO_ID_FK_ClientTypeId = ClientTypeId

		update #CrmContact_Extract_IO
		set IO_ID_CrmContactId = @IO_ID_FK_ContactId,
			IO_ID_Status = 'Matching data'
		where CRMContactId = @SourceContactId

		-- Get existing CorporateID if any
		update a
		set a.IO_ID_FK_CorporateId = b.CorporateId
		from #CrmContact_Extract_IO a
			inner join crm.dbo.TCRMContact b on b.CRMContactId = a.IO_ID_CRMContactId
		where a.IO_ID_CRMContactId = @IO_ID_FK_ContactId

		-- TCorporate
		set @tableName = 'TCorporate'
		set @msg='Extract '+@tableName
		raiserror(@msg,0,1) with nowait

		select corp.* into #Corporate_Extract_IO
		from CRM.dbo.TCorporate corp with(nolock)
		inner join #CrmContact_Extract_IO c on c.CorporateId = corp.CorporateId

		alter table #Corporate_Extract_IO add IO_ID_CorporateId int
		alter table #Corporate_Extract_IO add IO_ID_FK_IndClientId int
		alter table #Corporate_Extract_IO add IO_ID_FK_RefCorporateTypeId int
		alter table #Corporate_Extract_IO add IO_ID_Status varchar(100)
		alter table #Corporate_Extract_IO add IO_MigrationRef varchar(100)

		create index #Corporate_Extract_IO_PK on #Corporate_Extract_IO(CorporateId)
		create index #Corporate_Extract_IO_ID_IDX on #Corporate_Extract_IO(IO_ID_CorporateId)

		update #Corporate_Extract_IO
		set IO_ID_FK_IndClientId = IndClientId, -- There may be 0
			IO_MigrationRef = 'iO2iO:'+Convert(varchar(100), CorporateId),
			IO_ID_FK_RefCorporateTypeId = RefCorporateTypeId

		update #Corporate_Extract_IO
		set IO_ID_FK_IndClientId = @IndigoClientId
		where IO_ID_FK_IndClientId = @SourceIndigoClientId

		update a
		set a.IO_ID_CorporateId = b.IO_ID_FK_CorporateId
		from #Corporate_Extract_IO a
		inner join #CrmContact_Extract_IO b on b.CorporateId = a.CorporateId
		where b.IO_ID_FK_CorporateId is not null

		--- FINISH EXTRACTION
		--- *************************************

		-- ********************************************************
		-- IMPORT -- IMPORT -- IMPORT -- IMPORT -- IMPORT -- IMPORT
		-- ********************************************************


		-- **********************************************************
		-- Process TCampaignType
		set @tableName = 'TCampaignType'
		set @msg='Process '+@tableName
		raiserror(@msg,0,1) with nowait

		update a
			set a.IO_ID_CampaignTypeId = b.CampaignTypeId,
				a.IO_ID_Status = 'Matching data'
		from #CampaignType_Extract_IO a
			inner join crm.dbo.TCampaignType b on b.CampaignType = a.CampaignType
		where b.IndigoClientId = @IndigoClientId

		truncate table #InsertOutput
		Set @IO_MigrationRef = ''

		while (1=1) begin
			Select top 1 @IO_MigrationRef = IO_MigrationRef
			from #CampaignType_Extract_IO
			where IO_MigrationRef > @IO_MigrationRef
				and IO_ID_Status is null
			order by IO_MigrationRef

			if (@@ROWCOUNT=0) break

			insert into crm.dbo.TCampaignType(IndigoClientId, CampaignType, ArchiveFG, ConcurrencyId)
			OUTPUT @IO_MigrationRef, inserted.CampaignTypeId
			INTO #InsertOutput(IO_MIgrationRef, TheNewId)
			select IO_ID_FK_IndigoClientId, CampaignType, ArchiveFG, 1
			from #CampaignType_Extract_IO
			where IO_MigrationRef = @IO_MigrationRef

		end -- While

		update a
		set IO_ID_CampaignTypeId = b.TheNewId,
			IO_ID_Status = isnull(a.IO_ID_Status,'NEW')
		from #CampaignType_Extract_IO a
			inner join #InsertOutput b on b.IO_MigrationRef = a.IO_MigrationRef

		-- Log Audit data
		insert into crm.dbo.TCampaignTypeAudit(CampaignTypeId, IndigoClientId, CampaignType, ArchiveFG, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select a.CampaignTypeId, a.IndigoClientId, a.CampaignType, a.ArchiveFG, a.ConcurrencyId
			, Case b.IO_ID_Status when 'NEW' then 'C' else 'U' end, @Now, @StampUser
		from crm.dbo.TCampaignType a with(nolock)
			inner join #CampaignType_Extract_IO b on b.IO_ID_CampaignTypeId = a.CampaignTypeId
			inner join #InsertOutput c on c.TheNewId = b.IO_ID_CampaignTypeId -- redundant, but for safety reasons
		where b.IO_ID_Status is not null

		-- Remove unwanted CampaignType - automatically created
		delete a
		output
			deleted.CampaignId, deleted.CampaignTypeId, deleted.IndigoClientId, deleted.GroupId, deleted.CampaignName, deleted.ArchiveFG, deleted.IsOrganisational, deleted.ConcurrencyId
			, 'D', @Now, @StampUser
		into crm.dbo.TCampaignAudit(
			CampaignId, CampaignTypeId, IndigoClientId, GroupId, CampaignName, ArchiveFG, IsOrganisational, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from crm.dbo.TCampaign a
		left join #CampaignType_Extract_IO b on b.IO_ID_CampaignTypeId = a.CampaignTypeId
		where a.IndigoClientId = @IndigoClientId
			and b.IO_ID_CampaignTypeId is null

		delete a
		output
			deleted.CampaignTypeId, deleted.IndigoClientId, deleted.CampaignType, deleted.ArchiveFG, deleted.ConcurrencyId
			, 'D', @Now, @StampUser
		into crm.dbo.TCampaignTypeAudit(
			CampaignTypeId, IndigoClientId, CampaignType, ArchiveFG, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from crm.dbo.TCampaignType a
		left join #CampaignType_Extract_IO b on b.IO_ID_CampaignTypeId = a.CampaignTypeId
		where a.IndigoClientId = @IndigoClientId
			and b.IO_ID_CampaignTypeId is null

		-- **********************************************************
		-- Process TGrouping
		set @tableName = 'TGrouping'
		set @msg='Process '+@tableName
		raiserror(@msg,0,1) with nowait

		update a
		set a.IO_ID_GroupingId = b.GroupingId,
			a.IO_ID_Status = 'Matching data'
		from #Grouping_Extract_IO a
			inner join administration.dbo.TGrouping b on a.IO_ID_FK_IndigoClientId = b.IndigoClientId
		where a.Identifier = b.Identifier
			and a.IsPayable = b.IsPayable
			and a.ParentId is null
			and a.IO_ID_Status is null

		-- Get existing GroupingId, if they exist
		while (1=1) begin
			update a
			set a.IO_ID_FK_ParentId = b.IO_ID_GroupingId
			from #Grouping_Extract_IO a
				inner join #Grouping_Extract_IO b on a.ParentId = b.GroupingId
			where a.ParentId is not null
				and b.IO_ID_GroupingId is not null
				and a.IO_ID_FK_ParentId is null

			if (@@ROWCOUNT=0) break

			update a
			set a.IO_ID_GroupingId = b.GroupingId,
				a.IO_ID_Status = 'Matching data'
			from #Grouping_Extract_IO a
				inner join administration.dbo.TGrouping b on a.IO_ID_FK_IndigoClientId = b.IndigoClientId
			where a.Identifier = b.Identifier
				and a.IsPayable = b.IsPayable
				and a.ParentId is not null
				and a.IO_ID_Status is null
				and a.IO_ID_FK_ParentId = b.ParentId

		end

		set @IO_MigrationRef = ''
		truncate table #InsertOutput

		while (1=1) begin -- First, items without parent
			Select top 1 @IO_MigrationRef = IO_MigrationRef
			from #Grouping_Extract_IO
			where IO_MigrationRef > @IO_MigrationRef
				and IO_ID_Status is null
				and ParentId is null
			order by IO_MigrationRef

			if (@@ROWCOUNT=0) break

			insert into administration.dbo.TGrouping (Identifier, ParentId, IsPayable, IndigoClientId, ConcurrencyId)
			OUTPUT @IO_MigrationRef, inserted.GroupingId
			INTO #InsertOutput(IO_MIgrationRef, TheNewId)
			select Identifier, IO_ID_FK_ParentId, IsPayable, IO_ID_FK_IndigoClientId, 1
			from #Grouping_Extract_IO
			where IO_MigrationRef = @IO_MigrationRef
		end -- While

		update a
		set IO_ID_GroupingId = b.TheNewId,
		IO_ID_Status = isnull(a.IO_ID_Status,'NEW')
		from #Grouping_Extract_IO a
			inner join #InsertOutput b on b.IO_MigrationRef = a.IO_MigrationRef

		-- Log Audit data
		insert into administration.dbo.TGroupingAudit (GroupingId, Identifier, ParentId, IsPayable, IndigoClientId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select a.GroupingId, a.Identifier, a.ParentId, a.IsPayable, a.IndigoClientId, a.ConcurrencyId
			, Case b.IO_ID_Status when 'NEW' then 'C' else 'U' end, @Now, @StampUser
		from administration.dbo.TGrouping a with(nolock)
			inner join #Grouping_Extract_IO b on b.IO_ID_GroupingId = a.GroupingId
			inner join #InsertOutput c on c.TheNewId = b.IO_ID_GroupingId -- redundant, but for safety reasons
		where b.IO_ID_Status is not null


		--raiserror('Update child records',0,1) with nowait
		update a
		set a.IO_ID_FK_ParentId = b.IO_ID_GroupingId
		from #Grouping_Extract_IO a
		inner join #Grouping_Extract_IO b on b.GroupingId = a.ParentId
		where a.IO_ID_FK_ParentId is null
			and b.IO_ID_GroupingId is not null

		while (1=1) begin -- THIS HIERARCHY IS RECURSIVE

			truncate table #InsertOutput -- This will make sure only the last records get "updated"
			Set @IO_MigrationRef = ''

			while (1=1) begin -- Now, items WITH parent
				Select top 1 @IO_MigrationRef = IO_MigrationRef
				from #Grouping_Extract_IO
				where IO_MigrationRef > @IO_MigrationRef
					and IO_ID_Status is null
					and ParentId is not null
				order by IO_MigrationRef

				if (@@ROWCOUNT=0) break

				insert into administration.dbo.TGrouping (Identifier, ParentId, IsPayable, IndigoClientId, ConcurrencyId)
				OUTPUT @IO_MigrationRef, inserted.GroupingId
				INTO #InsertOutput(IO_MIgrationRef, TheNewId)
				select Identifier, IO_ID_FK_ParentId, IsPayable, IO_ID_FK_IndigoClientId, 1
				from #Grouping_Extract_IO
				where IO_MigrationRef = @IO_MigrationRef
			end -- While

			update a
			set IO_ID_GroupingId = b.TheNewId,
			IO_ID_Status = isnull(a.IO_ID_Status,'NEW')
			from #Grouping_Extract_IO a
				inner join #InsertOutput b on b.IO_MigrationRef = a.IO_MigrationRef

			-- Log Audit data
			insert into administration.dbo.TGroupingAudit (GroupingId, Identifier, ParentId, IsPayable, IndigoClientId, ConcurrencyId
				, StampAction, StampDateTime, StampUser)
			select a.GroupingId, a.Identifier, a.ParentId, a.IsPayable, a.IndigoClientId, a.ConcurrencyId
				, Case b.IO_ID_Status when 'NEW' then 'C' else 'U' end, @Now, @StampUser
			from administration.dbo.TGrouping a with(nolock)
				inner join #Grouping_Extract_IO b on b.IO_ID_GroupingId = a.GroupingId
				inner join #InsertOutput c on c.TheNewId = b.IO_ID_GroupingId -- to get only the last records
			where b.IO_ID_Status is not null

			--raiserror('Update child records',0,1) with nowait
			update a
			set a.IO_ID_FK_ParentId = b.IO_ID_GroupingId
			from #Grouping_Extract_IO a
			inner join #Grouping_Extract_IO b on b.GroupingId = a.ParentId
			where a.IO_ID_FK_ParentId is null
				and b.IO_ID_GroupingId is not null

			if not exists(select top 1 1 from #Grouping_Extract_IO where IO_ID_Status is null) break
		end -- while ()

		-- Cascade to dependent tables
		Update a
			set a.IO_ID_FK_GroupingId = b.IO_ID_GroupingId
		from #Group_Extract_IO a
		inner join #Grouping_Extract_IO b on b.GroupingId = a.GroupingId

		update a
			set a.IO_ID_FK_GroupingId = b.IO_ID_GroupingId
		from #Role_Extract_IO a
		inner join #Grouping_Extract_IO b on b.GroupingId = a.GroupingId

		-- **********************************************************
		-- Process TRole
		set @tableName = 'TRole'
		set @msg='Process '+@tableName
		raiserror(@msg,0,1) with nowait

		update a
		set a.IO_ID_RoleId = b.RoleId,
			a.IO_ID_Status = 'Matching data'
		from #Role_Extract_IO a
			inner join administration.dbo.TRole b on b.IndigoClientId = a.IO_ID_FK_IndigoClientId and b.GroupingId = a.IO_ID_FK_GroupingId and isnull(b.RefLicenseTypeId,0) = isnull(a.IO_ID_FK_RefLicenseTypeId,0)
		where a.Identifier = b.Identifier
			and a.SuperUser = b.SuperUser
			and isnull(a.Dashboard,'') = isnull(b.Dashboard,'')
			and IsNull(a.ShowGroupDashboard,0) = IsNull(b.ShowGroupDashboard,0)

		truncate table #InsertOutput
		Set @IO_MigrationRef = ''

		while (1=1) begin
			Select top 1 @IO_MigrationRef = IO_MigrationRef
			from #Role_Extract_IO
			where IO_MigrationRef > @IO_MigrationRef
				and IO_ID_Status is null
			order by IO_MigrationRef

			if (@@ROWCOUNT=0) break

			insert into administration.dbo.TRole(Identifier, GroupingId, SuperUser, IndigoClientId, RefLicenseTypeId, LicensedUserCount, Dashboard, ShowGroupDashboard, HourlyBillingRate, ConcurrencyId)
			OUTPUT @IO_MigrationRef, inserted.RoleId
			INTO #InsertOutput(IO_MIgrationRef, TheNewId)
			select Identifier, IO_ID_FK_GroupingId, SuperUser, IO_ID_FK_IndigoClientId, IO_ID_FK_RefLicenseTypeId, LicensedUserCount, Dashboard, ShowGroupDashboard, HourlyBillingRate, 1
			from #Role_Extract_IO
			where IO_MigrationRef = @IO_MigrationRef

		end -- While

		update a
		set IO_ID_RoleId = b.TheNewId,
			IO_ID_Status = isnull(a.IO_ID_Status,'NEW')
		from #Role_Extract_IO a
			inner join #InsertOutput b on b.IO_MigrationRef = a.IO_MigrationRef

		-- Log Audit data
		insert into administration.dbo.TRoleAudit(RoleId, Identifier, GroupingId, SuperUser, IndigoClientId, RefLicenseTypeId, LicensedUserCount, Dashboard, ShowGroupDashboard, HourlyBillingRate, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select a.RoleId, a.Identifier, a.GroupingId, a.SuperUser, a.IndigoClientId, a.RefLicenseTypeId, a.LicensedUserCount, a.Dashboard, a.ShowGroupDashboard, a.HourlyBillingRate, a.ConcurrencyId
			, Case b.IO_ID_Status when 'NEW' then 'C' else 'U' end, @Now, @StampUser
		from administration.dbo.TRole a with(nolock)
			inner join #Role_Extract_IO b on b.IO_ID_RoleId = a.RoleId
			inner join #InsertOutput c on c.TheNewId = b.IO_ID_RoleId -- redundant, but for safety reasons
		where b.IO_ID_Status is not null

		-- **********************************************************
		-- Process TGroup
		set @tableName = 'TGroup'
		set @msg='Process '+@tableName
		raiserror(@msg,0,1) with nowait

		-- Update top Group. There must be only one!
		update a
		set
			a.IO_ID_GroupId = b.GroupId,
			a.IO_ID_FK_CRMContactId = b.CRMContactId,
			a.IO_ID_Status = 'Matching data',
			a.IO_ID_FK_GroupingId = b.GroupingId
		from #Group_Extract_IO a,
			(select top 1 * from administration.dbo.TGroup b where IndigoClientId = @IndigoClientId and ParentId is null order by case Identifier when 'Organisation' then ' ' else Identifier end) b
		where --b.IndigoClientId = @IndigoClientId
			--and
			a.ParentId is null
			--and b.ParentId is null

		-- Update target Identifier with source
		update a
		set a.Identifier = b.Identifier,
				a.LegalEntity = b.LegalEntity
		from administration.dbo.TGroup a
			inner join #Group_Extract_IO b on b.IO_ID_GroupId = a.GroupId
		where a.IndigoClientId = @IndigoClientId
			and a.ParentId is null
			and b.ParentId is null

		-- Get existing Groups, created automatically
		update a
		set a.IO_ID_GroupId = b.GroupId,
			a.IO_ID_FK_ParentId = b.ParentId,
			a.IO_ID_FK_CRMContactId = b.CRMContactId,
			a.IO_ID_Status = 'Matching data'
		from #Group_Extract_IO a
		inner join administration.dbo.TGroup b on b.Identifier = a.Identifier and b.LegalEntity = a.LegalEntity
		where b.IndigoClientId = @IndigoClientId
			and a.ParentId is not null
			and b.ParentId is not null

		-- Apply MigrationRef to matching data
		update a
		set MigrationRef = b.MigrationRef
		from administration.dbo.TGroup a
			inner join #Group_Extract_IO b on b.IO_ID_GroupId = a.GroupId
		where a.IndigoClientId = @IndigoClientId

		-- Will need to update this later!
		update #Group_Extract_IO
		set IO_ID_FK_CRMContactId = -1
		where CRMContactId is not null and IO_ID_FK_CRMContactId is null

		insert into Administration.dbo.TGroup(
			Identifier, GroupingId, ParentId, CRMContactId, IndigoClientId, LegalEntity, GroupImageLocation, AcknowledgementsLocation, FinancialYearEnd, ApplyFactFindBranding
			, VatRegNbr, FSARegNbr, AuthorisationText, IsFSAPassport, FRNNumber, DocumentFileReference
			, ConcurrencyId, MigrationRef)
		select
			Identifier, IO_ID_FK_GroupingId, IO_ID_FK_ParentId, IO_ID_FK_CRMContactId, IO_ID_FK_IndigoClientId, LegalEntity, GroupImageLocation, AcknowledgementsLocation, FinancialYearEnd, ApplyFactFindBranding
			, VatRegNbr, FSARegNbr, AuthorisationText, IsFSAPassport, FRNNumber, DocumentFileReference
			, 1, IO_MigrationRef
		from #Group_Extract_IO
		where IO_ID_Status is null

		update a
		set a.IO_ID_GroupId = b.GroupId,
			a.IO_ID_Status = 'PRE-NEW'
		from #Group_Extract_IO a
		inner join Administration.dbo.TGroup b on b.MigrationRef = a.IO_MigrationRef
		where IO_ID_Status is null

		-- Apply MigrationRef
		update a
		set a.MigrationRef = b.MigrationRef
		from Administration.dbo.TGroup a
		inner join #Group_Extract_IO b on b.IO_ID_GroupId = a.GroupId
		where b.IO_ID_Status = 'PRE-NEW'
			and a.IndigoClientId = @IndigoClientId

		update #Group_Extract_IO
		set IO_ID_Status = 'NEW'
		where IO_ID_Status = 'PRE-NEW'

		-- 'Update ParentId, for extracted records'
		update a
		set IO_ID_FK_ParentId = b.IO_ID_GroupId
		from #Group_Extract_IO a
			inner join #Group_Extract_IO b on b.GroupId = a.ParentId
		where a.ParentId is not null

		-- Apply ParentId, to target table
		update a
		set ParentId = b.IO_ID_FK_ParentId
		from administration.dbo.TGroup a
			inner join #Group_Extract_IO b on b.IO_ID_GroupId = a.GroupId
		where a.IndigoClientId = @IndigoClientId
			and b.ParentId is not null

		-- Log Audit data
		insert into administration.dbo.TGroupAudit(
			GroupId, Identifier, GroupingId, ParentId, CRMContactId, IndigoClientId, LegalEntity, GroupImageLocation, AcknowledgementsLocation, FinancialYearEnd, ApplyFactFindBranding
			, VatRegNbr, FSARegNbr, AuthorisationText, IsFSAPassport, FRNNumber, DocumentFileReference, ConcurrencyId, MigrationRef
			, StampAction, StampDateTime, StampUser)
		select a.GroupId, a.Identifier, a.GroupingId, a.ParentId, a.CRMContactId, a.IndigoClientId, a.LegalEntity, a.GroupImageLocation, a.AcknowledgementsLocation, a.FinancialYearEnd, a.ApplyFactFindBranding
			, a.VatRegNbr, a.FSARegNbr, a.AuthorisationText, a.IsFSAPassport, a.FRNNumber, a.DocumentFileReference, a.ConcurrencyId, a.MigrationRef
			, Case b.IO_ID_Status when 'NEW' then 'C' else 'U' end, @Now, @StampUser
		from administration.dbo.TGroup a with(nolock)
			inner join #Group_Extract_IO b on b.IO_ID_GroupId = a.GroupId
		where b.IO_ID_Status is not null


		update a
		set a.IO_ID_FK_GroupId = b.IO_ID_GroupId
		from #Campaign_Extract_IO a
		inner join #Group_Extract_IO b on b.GroupId = a.GroupId

		-- **********************************************************
		-- Process TCampaign
		set @tableName = 'TCampaign'
		set @msg='Process '+@tableName
		raiserror(@msg,0,1) with nowait

		update a
		set a.IO_ID_FK_CampaignTypeId = b.IO_ID_CampaignTypeId
		from #Campaign_Extract_IO a
		inner join #CampaignType_Extract_IO b on b.CampaignTypeId = a.CampaignTypeId


		update a
			set a.IO_ID_CampaignId = b.CampaignId,
				a.IO_ID_Status = 'Matching data'
		from #Campaign_Extract_IO a
			inner join crm.dbo.TCampaign b on b.CampaignName = a.CampaignName
			left join crm.dbo.TCampaignType c on c.CampaignTypeId = a.IO_ID_FK_CampaignTypeId and c.IndigoClientId = @IndigoClientId
			left join Administration.dbo.TGroup d on d.GroupId = a.IO_ID_FK_GroupId and d.IndigoClientId = @IndigoClientId
		where b.IndigoClientId = @IndigoClientId

		truncate table #InsertOutput
		Set @IO_MigrationRef = ''

		while (1=1) begin
			Select top 1 @IO_MigrationRef = IO_MigrationRef
			from #Campaign_Extract_IO
			where IO_MigrationRef > @IO_MigrationRef
				and IO_ID_Status is null
			order by IO_MigrationRef

			if (@@ROWCOUNT=0) break

			insert into crm.dbo.TCampaign(CampaignTypeId, IndigoClientId, GroupId, CampaignName, ArchiveFG, IsOrganisational, ConcurrencyId)
			OUTPUT @IO_MigrationRef, inserted.CampaignId
			INTO #InsertOutput(IO_MIgrationRef, TheNewId)
			select IO_ID_FK_CampaignTypeId, IO_ID_FK_IndigoClientId, IO_ID_FK_GroupId, CampaignName, ArchiveFG, IsOrganisational, 1
			from #Campaign_Extract_IO
			where IO_MigrationRef = @IO_MigrationRef

		end -- While

		update a
		set IO_ID_CampaignId = b.TheNewId,
			IO_ID_Status = isnull(a.IO_ID_Status,'NEW')
		from #Campaign_Extract_IO a
			inner join #InsertOutput b on b.IO_MigrationRef = a.IO_MigrationRef

		-- Log Audit data
		insert into crm.dbo.TCampaignAudit(CampaignId, CampaignTypeId, IndigoClientId, GroupId, CampaignName, ArchiveFG, IsOrganisational, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select a.CampaignId, a.CampaignTypeId, a.IndigoClientId, a.GroupId, a.CampaignName, a.ArchiveFG, a.IsOrganisational, a.ConcurrencyId
			, Case b.IO_ID_Status when 'NEW' then 'C' else 'U' end, @Now, @StampUser
		from crm.dbo.TCampaign a with(nolock)
			inner join #Campaign_Extract_IO b on b.IO_ID_CampaignId = a.CampaignId
			inner join #InsertOutput c on c.TheNewId = b.IO_ID_CampaignId -- redundant, but for safety reasons
		where b.IO_ID_Status is not null


		-- **********************************************************
		-- Process TCampaignChannel
		set @tableName = 'TCampaignChannel'
		set @msg='Process '+@tableName
		raiserror(@msg,0,1) with nowait

		update a
			set a.IO_ID_CampaignChannelId = b.CampaignChannelId,
				a.ArchiveFg = b.ArchiveFg,
				a.IO_ID_Status = 'Matching data'
		from #CampaignChannel_Extract_IO a
			inner join crm.dbo.TCampaignChannel b on b.CampaignChannel = a.CampaignChannel
		where b.IndigoClientId = @IndigoClientId

		truncate table #InsertOutput
		Set @IO_MigrationRef = ''

		while (1=1) begin
			Select top 1 @IO_MigrationRef = IO_MigrationRef
			from #CampaignChannel_Extract_IO
			where IO_MigrationRef > @IO_MigrationRef
				and IO_ID_Status is null
			order by IO_MigrationRef

			if (@@ROWCOUNT=0) break

			insert into crm.dbo.TCampaignChannel(IndigoClientId, CampaignChannel, ArchiveFG, ConcurrencyId)
			OUTPUT @IO_MigrationRef, inserted.CampaignChannelId
			INTO #InsertOutput(IO_MIgrationRef, TheNewId)
			select IO_ID_FK_IndigoClientId, CampaignChannel, ArchiveFG, 1
			from #CampaignChannel_Extract_IO
			where IO_MigrationRef = @IO_MigrationRef

		end -- While

		update a
		set IO_ID_CampaignChannelId = b.TheNewId,
			IO_ID_Status = isnull(a.IO_ID_Status,'NEW')
		from #CampaignChannel_Extract_IO a
			inner join #InsertOutput b on b.IO_MigrationRef = a.IO_MigrationRef

		-- Log Audit data
		insert into crm.dbo.TCampaignChannelAudit(CampaignChannelId, IndigoClientId, CampaignChannel, ArchiveFG, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select a.CampaignChannelId, a.IndigoClientId, a.CampaignChannel, a.ArchiveFG, a.ConcurrencyId
			, Case b.IO_ID_Status when 'NEW' then 'C' else 'U' end, @Now, @StampUser
		from crm.dbo.TCampaignChannel a with(nolock)
			inner join #CampaignChannel_Extract_IO b on b.IO_ID_CampaignChannelId = a.CampaignChannelId
			inner join #InsertOutput c on c.TheNewId = b.IO_ID_CampaignChannelId -- redundant, but for safety reasons
		where b.IO_ID_Status is not null

		-- **********************************************************
		-- Process TCorporate
		set @tableName = 'TCorporate'
		set @msg='Process '+@tableName
		raiserror(@msg,0,1) with nowait

		update a
		set a.IO_ID_CorporateId = b.CorporateId,
			a.IO_ID_Status = 'Matching data'
		from #Corporate_Extract_IO a
			inner join CRM.dbo.TCorporate b on b.CorporateName = a.CorporateName and b.IndClientId = @SourceIndigoClientId
		where a.IO_ID_Status is null


		while (1=1) begin

			if not exists (select top 1 1 from #Corporate_Extract_IO where IO_ID_Status is null) break

			insert into CRM.dbo.TCorporate(IndClientId, CorporateName, ArchiveFg, BusinessType, RefCorporateTypeId, CompanyRegNo, EstIncorpDate, YearEnd, VatRegFg, VatRegNo, Extensible
			, ConcurrencyId, MigrationRef
			, CreatedOn, CreatedByUserId, UpdatedOn, UpdatedByUserId, LEI, LEIExpiryDate)
			select top 10000 IO_ID_FK_IndClientId, CorporateName, ArchiveFg, BusinessType, IO_ID_FK_RefCorporateTypeId, CompanyRegNo, EstIncorpDate, YearEnd, VatRegFg, VatRegNo, Extensible
			, 1, IO_MigrationRef
			, CreatedOn, CreatedByUserId, UpdatedOn, UpdatedByUserId, LEI, LEIExpiryDate
			from #Corporate_Extract_IO
			where IO_ID_Status is null

			update a
			set IO_ID_CorporateId = b.CorporateId,
				IO_ID_Status = 'PRE-NEW'
			from #Corporate_Extract_IO a
			inner join CRM.dbo.TCorporate b on b.MigrationRef = a.IO_MigrationRef
			where IO_ID_Status is null

			update a
			set a.MigrationRef = b.MigrationRef
			from CRM.dbo.TCorporate a
			inner join #Corporate_Extract_IO b on b.IO_ID_CorporateId = a.CorporateId
			where b.IO_ID_Status = 'PRE-NEW'

			update #Corporate_Extract_IO
			set IO_ID_Status = 'NEW'
			where IO_ID_Status = 'PRE-NEW'

		end

		-- Log Audit data
		insert into CRM.dbo.TCorporateAudit(CorporateId, IndClientId, CorporateName, ArchiveFg, BusinessType, RefCorporateTypeId, CompanyRegNo, EstIncorpDate, YearEnd, VatRegFg, VatRegNo, Extensible
			, ConcurrencyId, MigrationRef, LEI, LEIExpiryDate
			, StampAction, StampDateTime, StampUser)
		select a.CorporateId, a.IndClientId, a.CorporateName, a.ArchiveFg, a.BusinessType, a.RefCorporateTypeId, a.CompanyRegNo, a.EstIncorpDate, a.YearEnd, a.VatRegFg, a.VatRegNo, a.Extensible
			, a.ConcurrencyId, a.MigrationRef, a.LEI, a.LEIExpiryDate
			, Case b.IO_ID_Status when 'NEW' then 'C' else 'U' end, @Now, @StampUser
		from CRM.dbo.TCorporate a
		inner join #Corporate_Extract_IO b on b.IO_ID_CorporateId = a.CorporateId

		-- Cascade to dependent tables
		update a
		set a.IO_ID_FK_CorporateId = b.IO_ID_CorporateId
		from #CrmContact_Extract_IO a
		inner join #Corporate_Extract_IO b on b.CorporateId = a.CorporateId

		-- **********************************************************
		-- Process TCrmContact
		set @tableName = 'TCRMContact'
		set @msg='Process '+@tableName
		raiserror(@msg,0,1) with nowait

		update a
		set IO_ID_CRMContactId = b.CRMContactId,
			IO_ID_Status = 'Matching Data',
			IO_ID_FK_CorporateId = b.CorporateId
			--IO_ID_FK_OriginalAdviserCRMId = b.OriginalAdviserCRMId,
			--IO_ID_FK_CurrentAdviserCRMId = b.CurrentAdviserCRMId,
			--IO_ID_FK_RefSourceOfClientId = b.RefSourceOfClientId
		from #CrmContact_Extract_IO a
			inner join crm.dbo.TCRMContact b on b.CorporateName = a.CorporateName
		where a.IndClientId = 0 and b.IndClientId = 0
			and isnull(a.IO_ID_FK_RefCRMContactStatusId,0) = isnull(b.RefCRMContactStatusId,0)
			and a.IO_ID_FK_CorporateId is not null

		--update a
		--	set a.IO_ID_FK_CampaignDataId = b.IO_ID_CampaignDataId
		--from #CrmContact_Extract_IO a
		--	inner join #CampaignData_Extract_IO b on a.CampaignDataId = b.CampaignDataId

		update a
		set IO_ID_CRMContactId = b.CRMContactId,
			IO_ID_Status = 'Matching Data',
			IO_ID_FK_CorporateId = b.CorporateId
			--IO_ID_FK_OriginalAdviserCRMId = b.OriginalAdviserCRMId,
			--IO_ID_FK_CurrentAdviserCRMId = b.CurrentAdviserCRMId,
			--IO_ID_FK_RefSourceOfClientId = b.RefSourceOfClientId
		from #CrmContact_Extract_IO a
			inner join crm.dbo.TCRMContact b on b.CorporateName = a.CorporateName
		where a.IO_ID_FK_IndClientId = b.IndClientId
			and a.IO_ID_FK_CorporateId is not null

		update #CrmContact_Extract_IO
		set IO_ID_FK_OriginalAdviserCRMId = 0,
			IO_ID_FK_CurrentAdviserCRMId = 0
		where IO_ID_Status is null


		while (1=1) begin -- use batches of 10.000 records

			if not exists (select top 1 1 from #CrmContact_Extract_IO where IO_ID_Status is null) break

			insert into crm.dbo.TCRMContact(RefCRMContactStatusId, PersonId, CorporateId, TrustId, AdvisorRef, RefSourceOfClientId,
				SourceValue, Notes, ArchiveFg, LastName, FirstName, CorporateName, DOB, Postcode,
				OriginalAdviserCRMId, CurrentAdviserCRMId,
				CurrentAdviserName, CRMContactType, IndClientId, FactFindId, InternalContactFG, RefServiceStatusId,
				MigrationRef,
				CreatedDate, ExternalReference,
				CampaignDataId, AdditionalRef, AdviserAssignedByUserId, _ParentId, _ParentTable, _ParentDb, _OwnerId, FeeModelId, ServiceStatusStartDate, ClientTypeId, ConcurrencyId)
			select top 100000 IO_ID_FK_RefCRMContactStatusId, IO_ID_FK_PersonId, IO_ID_FK_CorporateId, IO_ID_FK_TrustId, AdvisorRef, IO_ID_FK_RefSourceOfClientId,
				SourceValue, Notes, ArchiveFg, LastName, FirstName, CorporateName, DOB, Postcode,
				IO_ID_FK_OriginalAdviserCRMId, IO_ID_FK_CurrentAdviserCRMId,
				CurrentAdviserName, CRMContactType, IO_ID_FK_IndClientId, IO_ID_FK_FactFindId, InternalContactFG, IO_ID_FK_RefServiceStatusId,
				IO_MigrationRef,
				CreatedDate, ExternalReference,
				IO_ID_FK_CampaignDataId, AdditionalRef, IO_ID_FK_AdviserAssignedByUserId, IO_ID_FK__ParentId, _ParentTable, _ParentDb, IO_ID_FK__OwnerId, IO_ID_FK_FeeModelId, ServiceStatusStartDate, IO_ID_FK_ClientTypeId, 1
			from #CrmContact_Extract_IO
			where IO_ID_Status is null
			order by CRMContactId

			update a
				set IO_ID_CRMContactId = b.CRMContactId,
				IO_ID_Status = 'PRE-NEW'
			from #CrmContact_Extract_IO a
				inner join crm.dbo.TCRMContact b on b.MigrationRef = a.IO_MigrationRef
			where IO_ID_Status is null

			-- Re-applying Original MigrationRef
			update a
				set a.MigrationRef = b.MigrationRef
			from crm.dbo.TCRMContact a
				inner join #CrmContact_Extract_IO b on b.IO_ID_CRMContactId = a.CRMContactId and a.IndClientId = b.IO_ID_FK_IndClientId
			where b.IO_ID_Status = 'PRE-NEW'

			update #CrmContact_Extract_IO
			set IO_ID_Status = 'NEW'
			where IO_ID_Status = 'PRE-NEW'

		end -- use batches of 100000 records

		update a
		set IO_ID_FK__OwnerId = b.IO_ID_CrmContactId
		from #CrmContact_Extract_IO a
		inner join #CrmContact_Extract_IO b on b.CRMContactId = a._OwnerId

		update a
		set a._OwnerId = b.IO_ID_FK__OwnerId
		from crm.dbo.TCRMContact a
		inner join #CrmContact_Extract_IO b on b.IO_ID_CRMContactId = a.CRMContactId

		-- Log Audit data
		insert into crm.dbo.TCRMContactAudit(
			CRMContactId, RefCRMContactStatusId, PersonId, CorporateId, TrustId, AdvisorRef, RefSourceOfClientId, SourceValue, Notes, ArchiveFg, LastName, FirstName, CorporateName, DOB, Postcode, OriginalAdviserCRMId
			, CurrentAdviserCRMId, CurrentAdviserName, CRMContactType, IndClientId, FactFindId, InternalContactFG, RefServiceStatusId, MigrationRef, CreatedDate, ExternalReference, CampaignDataId
			, AdditionalRef, AdviserAssignedByUserId, _ParentId, _ParentTable, _ParentDb, _OwnerId, ConcurrencyId, FeeModelId, ServiceStatusStartDate, ClientTypeId, IsHeadOfFamilyGroup, FamilyGroupCreationDate, IsDeleted
			, StampAction, StampDateTime, StampUser)
		select
			a.CRMContactId, a.RefCRMContactStatusId, a.PersonId, a.CorporateId, a.TrustId, a.AdvisorRef, a.RefSourceOfClientId, a.SourceValue, a.Notes, a.ArchiveFg, a.LastName, a.FirstName, a.CorporateName, a.DOB, a.Postcode, a.OriginalAdviserCRMId
			, a.CurrentAdviserCRMId, a.CurrentAdviserName, a.CRMContactType, a.IndClientId, a.FactFindId, a.InternalContactFG, a.RefServiceStatusId, a.MigrationRef, a.CreatedDate, a.ExternalReference, a.CampaignDataId
			, a.AdditionalRef, a.AdviserAssignedByUserId, a._ParentId, a._ParentTable, a._ParentDb, a._OwnerId, a.ConcurrencyId, a.FeeModelId, a.ServiceStatusStartDate, a.ClientTypeId, a.IsHeadOfFamilyGroup, a.FamilyGroupCreationDate, a.IsDeleted
			, Case b.IO_ID_Status when 'NEW' then 'C' else 'U' end, @Now, @StampUser
		from CRM.dbo.TCRMContact a
		inner join #CrmContact_Extract_IO b on b.IO_ID_CrmContactId = a.CRMContactId

		-- Cascade to dependent tables
		update a
			set a.IO_ID_FK_CrmContactId = b.IO_ID_CrmContactId
		from #Group_Extract_IO a
		inner join #CrmContact_Extract_IO b on b.CRMContactId = a.CRMContactId

		-- Update already migrated groups
		update a
		set a.CrmContactId = b.IO_ID_FK_CrmContactId
		from Administration.dbo.TGroup a
			inner join #Group_Extract_IO b on b.IO_ID_GroupId = a.GroupId
		where a.IndigoClientId = @IndigoClientId
			and b.CRMContactId is not null and a.CRMContactId = -1

		update a
		set a.CrmContactId = b.IO_ID_FK_CrmContactId
		from Administration.dbo.TGroupAudit a
			inner join #Group_Extract_IO b on b.IO_ID_GroupId = a.GroupId
		where a.IndigoClientId = @IndigoClientId
			and b.CRMContactId is not null and a.CRMContactId = -1

		if @tx = 0 begin
			commit transaction TX
			set @msg=@ProcName+': commit transaction TX'
			raiserror(@msg,0,1) with nowait
		end

		exec dbo.spStopCreateTenantModule @IndigoClientId, @SourceIndigoClientId, @ProcName

		if object_id('tempdb..#InsertOutput') is not null drop table #InsertOutput
		if object_id('tempdb..#Grouping_Extract_IO') is not null drop table #Grouping_Extract_IO -- SEL/IMP/AUD/CASC group + role
		if object_id('tempdb..#CrmContact_Extract_IO') is not null drop table #CrmContact_Extract_IO -- SEL/IMP/AUD/CASC group
		if object_id('tempdb..#Corporate_Extract_IO') is not null drop table #Corporate_Extract_IO -- SEL/IMP/AUD/CASC CrmContact
		if object_id('tempdb..#Role_Extract_IO') is not null drop table #Role_Extract_IO -- SEL/IMP/AUD
		if object_id('tempdb..#Group_Extract_IO') is not null drop table #Group_Extract_IO -- SEL/IMP/AUD
		if object_id('tempdb..#CampaignType_Extract_IO') is not null drop table #CampaignType_Extract_IO
		if object_id('tempdb..#Campaign_Extract_IO') is not null drop table #Campaign_Extract_IO
		if object_id('tempdb..#CampaignChannel_Extract_IO') is not null drop table #CampaignChannel_Extract_IO
		
	end try
	begin catch
		declare @Errmsg varchar(max) = @ProcName+'
'+ERROR_MESSAGE()

		if @tx = 0 begin
			set @msg=@ProcName+': rollback transaction TX'
			raiserror(@msg,0,1) with nowait
			rollback transaction TX
		end
		if object_id('tempdb..#InsertOutput') is not null drop table #InsertOutput
		if object_id('tempdb..#Grouping_Extract_IO') is not null drop table #Grouping_Extract_IO -- SEL/IMP/AUD/CASC group + role
		if object_id('tempdb..#CrmContact_Extract_IO') is not null drop table #CrmContact_Extract_IO -- SEL/IMP/AUD/CASC group
		if object_id('tempdb..#Corporate_Extract_IO') is not null drop table #Corporate_Extract_IO -- SEL/IMP/AUD/CASC CrmContact
		if object_id('tempdb..#Role_Extract_IO') is not null drop table #Role_Extract_IO -- SEL/IMP/AUD
		if object_id('tempdb..#Group_Extract_IO') is not null drop table #Group_Extract_IO -- SEL/IMP/AUD
		if object_id('tempdb..#CampaignType_Extract_IO') is not null drop table #CampaignType_Extract_IO
		if object_id('tempdb..#Campaign_Extract_IO') is not null drop table #Campaign_Extract_IO
		if object_id('tempdb..#CampaignChannel_Extract_IO') is not null drop table #CampaignChannel_Extract_IO
		raiserror(@Errmsg,16,1)
	end catch	
end
GO
