CREATE TABLE [dbo].[TAtrCategoryCombined]
(
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TAtrCategoryCombined_Guid] DEFAULT (newid()),
[AtrCategoryId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[TenantGuid] [uniqueidentifier] NOT NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TAtrCategoryCombined_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrCategoryCombined_ConcurrencyId] DEFAULT ((1)),
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_D1F131F6_A9D5_490D_AD45_78C45E1E9FD5_1253071700] DEFAULT (newid())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TAtrCategoryCombined_4] on [dbo].[TAtrCategoryCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TAtrCategoryCombined] set msrepl_tran_version = newid() from [dbo].[TAtrCategoryCombined], inserted  
     where      [dbo].[TAtrCategoryCombined].[Guid] = inserted.[Guid] 
 
GO
EXEC sp_settriggerorder N'[dbo].[sp_MSsync_upd_trig_TAtrCategoryCombined_4]', 'first', 'update', null
GO
ALTER TABLE [dbo].[TAtrCategoryCombined] ADD CONSTRAINT [PK_TAtrCategoryCombined] PRIMARY KEY NONCLUSTERED  ([Guid])
GO
