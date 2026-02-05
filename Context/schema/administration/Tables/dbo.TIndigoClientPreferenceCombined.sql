CREATE TABLE [dbo].[TIndigoClientPreferenceCombined]
(
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TIndigoClientPreferenceCombined_Guid] DEFAULT (newid()),
[IndigoClientPreferenceId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[PreferenceName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Value] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Disabled] [bit] NOT NULL CONSTRAINT [DF_TIndigoClientPreferenceCombined_Disabled] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIndigoClientPreferenceCombined_ConcurrencyId] DEFAULT ((1)),
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_6DA2EB73_9F99_4BB4_B4BB_AD8AAAB319A7_2063398470] DEFAULT (newid())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TIndigoClientPreferenceCombined_4] on [dbo].[TIndigoClientPreferenceCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TIndigoClientPreferenceCombined] set msrepl_tran_version = newid() from [dbo].[TIndigoClientPreferenceCombined], inserted  
     where      [dbo].[TIndigoClientPreferenceCombined].[Guid] = inserted.[Guid] 
 
GO
EXEC sp_settriggerorder N'[dbo].[sp_MSsync_upd_trig_TIndigoClientPreferenceCombined_4]', 'first', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TIndigoClientPreferenceCombined_5] on [dbo].[TIndigoClientPreferenceCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TIndigoClientPreferenceCombined] set msrepl_tran_version = newid() from [dbo].[TIndigoClientPreferenceCombined], inserted  
     where      [dbo].[TIndigoClientPreferenceCombined].[Guid] = inserted.[Guid] 
 
GO
ALTER TABLE [dbo].[TIndigoClientPreferenceCombined] ADD CONSTRAINT [PK_TIndigoClientPreferenceCombined] PRIMARY KEY NONCLUSTERED  ([Guid]) WITH (FILLFACTOR=80)
GO
