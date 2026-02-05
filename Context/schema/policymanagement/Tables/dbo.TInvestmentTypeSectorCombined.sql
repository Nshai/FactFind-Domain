CREATE TABLE [dbo].[TInvestmentTypeSectorCombined]
(
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TInvestmentTypeSectorCombined_Guid] DEFAULT (newid()),
[InvestmentTypeSectorId] [int] NOT NULL,
[CategoryId] [int] NOT NULL,
[FundTypeId] [int] NOT NULL,
[InvestmentTypeId] [int] NOT NULL,
[InvestmentTypeGuid] [uniqueidentifier] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_A2594371_71D7_45B1_970B_9F3AA77AC0D6_1061123071] DEFAULT (newid())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TInvestmentTypeSectorCombined_5] on [dbo].[TInvestmentTypeSectorCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TInvestmentTypeSectorCombined] set msrepl_tran_version = newid() from [dbo].[TInvestmentTypeSectorCombined], inserted  
     where      [dbo].[TInvestmentTypeSectorCombined].[Guid] = inserted.[Guid] 
 
GO
EXEC sp_settriggerorder N'[dbo].[sp_MSsync_upd_trig_TInvestmentTypeSectorCombined_5]', 'first', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TInvestmentTypeSectorCombined_6] on [dbo].[TInvestmentTypeSectorCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TInvestmentTypeSectorCombined] set msrepl_tran_version = newid() from [dbo].[TInvestmentTypeSectorCombined], inserted  
     where      [dbo].[TInvestmentTypeSectorCombined].[Guid] = inserted.[Guid] 
 
GO
ALTER TABLE [dbo].[TInvestmentTypeSectorCombined] ADD CONSTRAINT [PK_TInvestmentTypeSectorCombined] PRIMARY KEY NONCLUSTERED  ([Guid]) WITH (FILLFACTOR=80)
GO
