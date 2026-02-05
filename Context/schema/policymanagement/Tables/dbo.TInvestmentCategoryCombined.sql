CREATE TABLE [dbo].[TInvestmentCategoryCombined]
(
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TInvestmentCategoryCombined_Guid] DEFAULT (newid()),
[InvestmentCategoryId] [int] NOT NULL,
[Descriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[OrderNbr] [int] NULL,
[ChartSeriesColour] [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_E49DB012_5F0F_4673_BF3A_1FA8FFE00972_632597542] DEFAULT (newid())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TInvestmentCategoryCombined_5] on [dbo].[TInvestmentCategoryCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TInvestmentCategoryCombined] set msrepl_tran_version = newid() from [dbo].[TInvestmentCategoryCombined], inserted  
     where      [dbo].[TInvestmentCategoryCombined].[Guid] = inserted.[Guid] 
 
GO
EXEC sp_settriggerorder N'[dbo].[sp_MSsync_upd_trig_TInvestmentCategoryCombined_5]', 'first', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TInvestmentCategoryCombined_6] on [dbo].[TInvestmentCategoryCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TInvestmentCategoryCombined] set msrepl_tran_version = newid() from [dbo].[TInvestmentCategoryCombined], inserted  
     where      [dbo].[TInvestmentCategoryCombined].[Guid] = inserted.[Guid] 
 
GO
ALTER TABLE [dbo].[TInvestmentCategoryCombined] ADD CONSTRAINT [PK_TInvestmentCategoryCombined] PRIMARY KEY NONCLUSTERED  ([Guid]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TInvestmentCategoryCombined] ADD CONSTRAINT [IX_TInvestmentCategoryCombined_1] UNIQUE NONCLUSTERED  ([InvestmentCategoryId], [IndigoClientGuid]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TInvestmentCategoryCombined] ON [dbo].[TInvestmentCategoryCombined] ([IndigoClientGuid]) WITH (FILLFACTOR=80)
GO
