CREATE TABLE [dbo].[TAtrAssetClassCombined]
(
[Guid] [uniqueidentifier] NOT NULL,
[AtrAssetClassId] [int] NOT NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Allocation] [decimal] (5, 2) NULL,
[Ordering] [tinyint] NULL,
[AtrRefAssetClassId] [int] NULL,
[AtrPortfolioGuid] [uniqueidentifier] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrAssetClassCombined_ConcurrencyId] DEFAULT ((1)),
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_1806B912_9518_436F_9997_259372BDC9BF_399392542] DEFAULT (newid())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TAtrAssetClassCombined_4] on [dbo].[TAtrAssetClassCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TAtrAssetClassCombined] set msrepl_tran_version = newid() from [dbo].[TAtrAssetClassCombined], inserted  
     where      [dbo].[TAtrAssetClassCombined].[Guid] = inserted.[Guid] 
 
GO
EXEC sp_settriggerorder N'[dbo].[sp_MSsync_upd_trig_TAtrAssetClassCombined_4]', 'first', 'update', null
GO
ALTER TABLE [dbo].[TAtrAssetClassCombined] ADD CONSTRAINT [PK_TAtrAssetClassCombined] PRIMARY KEY NONCLUSTERED  ([Guid]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrAssetClassCombined_AtrPortfolioGuid] ON [dbo].[TAtrAssetClassCombined] ([AtrPortfolioGuid]) WITH (FILLFACTOR=80)
GO
