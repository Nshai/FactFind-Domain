CREATE TABLE [dbo].[TIndigoClientCombined]
(
[Guid] [uniqueidentifier] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[RefEnvironmentId] [int] NOT NULL,
[IsPortfolioConstructionProvider] [bit] NOT NULL CONSTRAINT [DF_TIndigoClientCombined_IsPortfolioConstructionProvider] DEFAULT ((0)),
[IsAuthorProvider] [bit] NOT NULL CONSTRAINT [DF_TIndigoClientCombined_IsAuthorProvider] DEFAULT ((0)),
[IsAtrProvider] [bit] NOT NULL CONSTRAINT [DF_TIndigoClientCombined_IsAtrProvider] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIndigoClientCombined_ConcurrencyId] DEFAULT ((1)),
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_D40890EE_F554_443B_ADDD_DD92089B0F04_599061270] DEFAULT (newid())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TIndigoClientCombined_4] on [dbo].[TIndigoClientCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TIndigoClientCombined] set msrepl_tran_version = newid() from [dbo].[TIndigoClientCombined], inserted  
     where      [dbo].[TIndigoClientCombined].[Guid] = inserted.[Guid] 
 
GO
EXEC sp_settriggerorder N'[dbo].[sp_MSsync_upd_trig_TIndigoClientCombined_4]', 'first', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TIndigoClientCombined_5] on [dbo].[TIndigoClientCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TIndigoClientCombined] set msrepl_tran_version = newid() from [dbo].[TIndigoClientCombined], inserted  
     where      [dbo].[TIndigoClientCombined].[Guid] = inserted.[Guid] 
 
GO
ALTER TABLE [dbo].[TIndigoClientCombined] ADD CONSTRAINT [PK_TIndigoClientCombined] PRIMARY KEY NONCLUSTERED  ([Guid]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TIndigoClientCombined_IndigoClientId] ON [dbo].[TIndigoClientCombined] ([IndigoClientId]) WITH (FILLFACTOR=80)
GO
