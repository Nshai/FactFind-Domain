CREATE TABLE [dbo].[TToleranceLevelCombined]
(
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TToleranceLevelCombined_Guid] DEFAULT (newid()),
[ToleranceLevelId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[Tolerance] [money] NOT NULL,
[PurchaseTolerance] [money] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_750C42E9_12D1_4BFC_AF94_E18E33D927BF_1416600335] DEFAULT (newid())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TToleranceLevelCombined_5] on [dbo].[TToleranceLevelCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TToleranceLevelCombined] set msrepl_tran_version = newid() from [dbo].[TToleranceLevelCombined], inserted  
     where      [dbo].[TToleranceLevelCombined].[Guid] = inserted.[Guid] 
 
GO
EXEC sp_settriggerorder N'[dbo].[sp_MSsync_upd_trig_TToleranceLevelCombined_5]', 'first', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TToleranceLevelCombined_6] on [dbo].[TToleranceLevelCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TToleranceLevelCombined] set msrepl_tran_version = newid() from [dbo].[TToleranceLevelCombined], inserted  
     where      [dbo].[TToleranceLevelCombined].[Guid] = inserted.[Guid] 
 
GO
ALTER TABLE [dbo].[TToleranceLevelCombined] ADD CONSTRAINT [PK_TToleranceLevelCombined] PRIMARY KEY NONCLUSTERED  ([Guid]) WITH (FILLFACTOR=80)
GO
