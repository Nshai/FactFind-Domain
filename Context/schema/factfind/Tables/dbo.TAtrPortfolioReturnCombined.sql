CREATE TABLE [dbo].[TAtrPortfolioReturnCombined]
(
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TAtrPortfolioReturnCombined_Guid] DEFAULT (newid()),
[AtrPortfolioReturnId] [int] NOT NULL,
[AtrPortfolioGuid] [uniqueidentifier] NOT NULL,
[AtrRefPortfolioTermId] [int] NOT NULL,
[LowerReturn] [decimal] (10, 4) NULL,
[MidReturn] [decimal] (10, 4) NULL,
[UpperReturn] [decimal] (10, 4) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrPortfolioReturnCombined_ConcurrencyId] DEFAULT ((1)),
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_6F042326_5075_40D2_9603_7377BF31BDD8_1250871573] DEFAULT (newid())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TAtrPortfolioReturnCombined_3] on [dbo].[TAtrPortfolioReturnCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TAtrPortfolioReturnCombined] set msrepl_tran_version = newid() from [dbo].[TAtrPortfolioReturnCombined], inserted  
     where      [dbo].[TAtrPortfolioReturnCombined].[Guid] = inserted.[Guid] 
 
GO
EXEC sp_settriggerorder N'[dbo].[sp_MSsync_upd_trig_TAtrPortfolioReturnCombined_3]', 'first', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TAtrPortfolioReturnCombined_4] on [dbo].[TAtrPortfolioReturnCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TAtrPortfolioReturnCombined] set msrepl_tran_version = newid() from [dbo].[TAtrPortfolioReturnCombined], inserted  
     where      [dbo].[TAtrPortfolioReturnCombined].[Guid] = inserted.[Guid] 
 
GO
ALTER TABLE [dbo].[TAtrPortfolioReturnCombined] ADD CONSTRAINT [PK_TAtrPortfolioReturnCombined] PRIMARY KEY NONCLUSTERED  ([Guid]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrPortfolioReturnCombined_AtrPortfolioGuid] ON [dbo].[TAtrPortfolioReturnCombined] ([AtrPortfolioGuid]) WITH (FILLFACTOR=80)
GO
