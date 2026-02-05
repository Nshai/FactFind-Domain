CREATE TABLE [dbo].[TUserEmailConfigCombined]
(
[colId] [int] NOT NULL IDENTITY(1, 1),
[EmailGuid] [uniqueidentifier] NOT NULL,
[UserGuid] [uniqueidentifier] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TUserEmailConfigCombined_ConcurrencyId] DEFAULT ((1)),
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_F682DC68_0201_4B47_9217_45872590239E_387636574] DEFAULT (newid())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TUserEmailConfigCombined_5] on [dbo].[TUserEmailConfigCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TUserEmailConfigCombined] set msrepl_tran_version = newid() from [dbo].[TUserEmailConfigCombined], inserted  
     where      [dbo].[TUserEmailConfigCombined].[colId] = inserted.[colId] 
 
GO
EXEC sp_settriggerorder N'[dbo].[sp_MSsync_upd_trig_TUserEmailConfigCombined_5]', 'first', 'update', null
GO
ALTER TABLE [dbo].[TUserEmailConfigCombined] ADD CONSTRAINT [PK__TUserEmailConfig__180F0197] PRIMARY KEY CLUSTERED  ([colId])
GO
