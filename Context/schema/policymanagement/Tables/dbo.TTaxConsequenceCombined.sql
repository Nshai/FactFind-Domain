CREATE TABLE [dbo].[TTaxConsequenceCombined]
(
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TTaxConsequenceCombined_Guid] DEFAULT (newid()),
[TaxConsequenceId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_DBFC84D8_0A0A_4145_B3C3_BCF66E592831_1800601703] DEFAULT (newid())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TTaxConsequenceCombined_5] on [dbo].[TTaxConsequenceCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TTaxConsequenceCombined] set msrepl_tran_version = newid() from [dbo].[TTaxConsequenceCombined], inserted  
     where      [dbo].[TTaxConsequenceCombined].[Guid] = inserted.[Guid] 
 
GO
EXEC sp_settriggerorder N'[dbo].[sp_MSsync_upd_trig_TTaxConsequenceCombined_5]', 'first', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TTaxConsequenceCombined_6] on [dbo].[TTaxConsequenceCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TTaxConsequenceCombined] set msrepl_tran_version = newid() from [dbo].[TTaxConsequenceCombined], inserted  
     where      [dbo].[TTaxConsequenceCombined].[Guid] = inserted.[Guid] 
 
GO
ALTER TABLE [dbo].[TTaxConsequenceCombined] ADD CONSTRAINT [PK_TTaxConsequenceCombined] PRIMARY KEY NONCLUSTERED  ([Guid]) WITH (FILLFACTOR=80)
GO
