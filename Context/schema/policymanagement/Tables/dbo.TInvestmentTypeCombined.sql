CREATE TABLE [dbo].[TInvestmentTypeCombined]
(
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TInvestmentTypeCombined_Guid] DEFAULT (newid()),
[InvestmentTypeId] [int] NOT NULL,
[Descriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[InvestmentCategoryId] [int] NOT NULL,
[InvestmentCategoryGuid] [uniqueidentifier] NOT NULL,
[DefaultRiskRating] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_D2603953_7AB2_4102_8747_8B1119D09B68_1032598967] DEFAULT (newid())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TInvestmentTypeCombined_5] on [dbo].[TInvestmentTypeCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TInvestmentTypeCombined] set msrepl_tran_version = newid() from [dbo].[TInvestmentTypeCombined], inserted  
     where      [dbo].[TInvestmentTypeCombined].[Guid] = inserted.[Guid] 
 
GO
EXEC sp_settriggerorder N'[dbo].[sp_MSsync_upd_trig_TInvestmentTypeCombined_5]', 'first', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TInvestmentTypeCombined_6] on [dbo].[TInvestmentTypeCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TInvestmentTypeCombined] set msrepl_tran_version = newid() from [dbo].[TInvestmentTypeCombined], inserted  
     where      [dbo].[TInvestmentTypeCombined].[Guid] = inserted.[Guid] 
 
GO
ALTER TABLE [dbo].[TInvestmentTypeCombined] ADD CONSTRAINT [PK_TInvestmentTypeCombined] PRIMARY KEY NONCLUSTERED  ([Guid]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TInvestmentTypeCombined] ADD CONSTRAINT [IX_TInvestmentTypeCombined_1] UNIQUE NONCLUSTERED  ([InvestmentTypeId], [IndigoClientGuid]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TInvestmentTypeCombined] ON [dbo].[TInvestmentTypeCombined] ([IndigoClientGuid]) WITH (FILLFACTOR=80)
GO
