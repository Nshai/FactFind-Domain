CREATE TABLE [dbo].[TSaleExplanationCombined]
(
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TSaleExplanationCombined_Guid] DEFAULT (newid()),
[SaleExplanationId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSaleExplanationCombined_ConcurrencyId] DEFAULT ((1)),
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_CA269419_B1B5_4AFE_86FB_6EAF6C77790D_53119480] DEFAULT (newid())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TSaleExplanationCombined_5] on [dbo].[TSaleExplanationCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TSaleExplanationCombined] set msrepl_tran_version = newid() from [dbo].[TSaleExplanationCombined], inserted  
     where      [dbo].[TSaleExplanationCombined].[Guid] = inserted.[Guid] 
 
GO
EXEC sp_settriggerorder N'[dbo].[sp_MSsync_upd_trig_TSaleExplanationCombined_5]', 'first', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TSaleExplanationCombined_6] on [dbo].[TSaleExplanationCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TSaleExplanationCombined] set msrepl_tran_version = newid() from [dbo].[TSaleExplanationCombined], inserted  
     where      [dbo].[TSaleExplanationCombined].[Guid] = inserted.[Guid] 
 
GO
ALTER TABLE [dbo].[TSaleExplanationCombined] ADD CONSTRAINT [PK_TSaleExplanationCombined] PRIMARY KEY NONCLUSTERED  ([Guid]) WITH (FILLFACTOR=80)
GO
