CREATE TABLE [dbo].[TAtrPortfolioCombined]
(
[Guid] [uniqueidentifier] NOT NULL,
[AtrPortfolioId] [int] NOT NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[AtrRefPortfolioTypeId] [int] NULL,
[Active] [bit] NOT NULL,
[AnnualReturn] [decimal] (10, 4) NULL,
[Volatility] [decimal] (10, 4) NULL,
[AtrTemplateGuid] [uniqueidentifier] NOT NULL,
[IndigoClientId] [int] NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrPortfolioCombined_ConcurrencyId] DEFAULT ((1)),
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_85599570_5A3E_40F8_9A24_29807158688B_946870490] DEFAULT (newid())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TAtrPortfolioCombined_3] on [dbo].[TAtrPortfolioCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TAtrPortfolioCombined] set msrepl_tran_version = newid() from [dbo].[TAtrPortfolioCombined], inserted  
     where      [dbo].[TAtrPortfolioCombined].[Guid] = inserted.[Guid] 
 
GO
EXEC sp_settriggerorder N'[dbo].[sp_MSsync_upd_trig_TAtrPortfolioCombined_3]', 'first', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TAtrPortfolioCombined_4] on [dbo].[TAtrPortfolioCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TAtrPortfolioCombined] set msrepl_tran_version = newid() from [dbo].[TAtrPortfolioCombined], inserted  
     where      [dbo].[TAtrPortfolioCombined].[Guid] = inserted.[Guid] 
 
GO
ALTER TABLE [dbo].[TAtrPortfolioCombined] ADD CONSTRAINT [PK_TAtrPortfolioCombined] PRIMARY KEY NONCLUSTERED  ([Guid]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrPortfolioCombined_AtrTemplateGuid] ON [dbo].[TAtrPortfolioCombined] ([AtrTemplateGuid]) WITH (FILLFACTOR=80)
GO
