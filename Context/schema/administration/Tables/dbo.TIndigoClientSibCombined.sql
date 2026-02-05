CREATE TABLE [dbo].[TIndigoClientSibCombined]
(
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TIndigoClientSibCombined_Guid] DEFAULT (newid()),
[IndigoClientSibId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[GroupId] [int] NULL,
[Sib] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[IsAgencyCode] [bit] NOT NULL CONSTRAINT [DF_TIndigoClientSibCombined_IsAgencyCode] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIndigoClientSibCombined_ConcurrencyId] DEFAULT ((1)),
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_B6442E26_BCF8_4689_8DDB_4A726A96418D_1780305502] DEFAULT (newid())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TIndigoClientSibCombined_5] on [dbo].[TIndigoClientSibCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TIndigoClientSibCombined] set msrepl_tran_version = newid() from [dbo].[TIndigoClientSibCombined], inserted  
     where      [dbo].[TIndigoClientSibCombined].[Guid] = inserted.[Guid] 
 
GO
EXEC sp_settriggerorder N'[dbo].[sp_MSsync_upd_trig_TIndigoClientSibCombined_5]', 'first', 'update', null
GO
ALTER TABLE [dbo].[TIndigoClientSibCombined] ADD CONSTRAINT [PK_TIndigoClientSibCombined] PRIMARY KEY NONCLUSTERED  ([Guid])
GO
