CREATE TABLE [dbo].[TAtrMatrixTermCombined]
(
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TAtrMatrixTermCombined_Guid] DEFAULT (newid()),
[AtrMatrixTermId] [int] NOT NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [tinyint] NOT NULL,
[Starting] [tinyint] NULL,
[Ending] [tinyint] NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[AtrTemplateGuid] [uniqueidentifier] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrMatrixTermCombined_ConcurrencyId] DEFAULT ((1)),
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_95AA76F1_4689_4865_83BC_7D7AF71D67E1_1201543464] DEFAULT (newid())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TAtrMatrixTermCombined_4] on [dbo].[TAtrMatrixTermCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TAtrMatrixTermCombined] set msrepl_tran_version = newid() from [dbo].[TAtrMatrixTermCombined], inserted  
     where      [dbo].[TAtrMatrixTermCombined].[Guid] = inserted.[Guid] 
 
GO
EXEC sp_settriggerorder N'[dbo].[sp_MSsync_upd_trig_TAtrMatrixTermCombined_4]', 'first', 'update', null
GO
ALTER TABLE [dbo].[TAtrMatrixTermCombined] ADD CONSTRAINT [PK_TAtrMatrixTermCombined] PRIMARY KEY NONCLUSTERED  ([Guid])
GO
