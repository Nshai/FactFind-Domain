CREATE TABLE [dbo].[TRiskProfileCombined]
(
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TRiskProfileCombined_Guid] DEFAULT (newid()),
[RiskProfileId] [int] NOT NULL,
[Descriptor] [varchar] (5000) COLLATE Latin1_General_CI_AS NOT NULL,
[BriefDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[RiskNumber] [int] NOT NULL,
[LowerBand] [int] NULL,
[UpperBand] [int] NULL,
[AtrTemplateGuid] [uniqueidentifier] NULL,
[ConcurrencyId] [int] NOT NULL,
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_81F5B1EF_EFFD_41C4_A43B_66C922820853_459408956] DEFAULT (newid())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TRiskProfileCombined_5] on [dbo].[TRiskProfileCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TRiskProfileCombined] set msrepl_tran_version = newid() from [dbo].[TRiskProfileCombined], inserted  
     where      [dbo].[TRiskProfileCombined].[Guid] = inserted.[Guid] 
 
GO
EXEC sp_settriggerorder N'[dbo].[sp_MSsync_upd_trig_TRiskProfileCombined_5]', 'first', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TRiskProfileCombined_6] on [dbo].[TRiskProfileCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TRiskProfileCombined] set msrepl_tran_version = newid() from [dbo].[TRiskProfileCombined], inserted  
     where      [dbo].[TRiskProfileCombined].[Guid] = inserted.[Guid] 
 
GO
ALTER TABLE [dbo].[TRiskProfileCombined] ADD CONSTRAINT [PK_TRiskProfileCombined] PRIMARY KEY NONCLUSTERED  ([Guid]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRiskProfileCombined_AtrTemplateGuid] ON [dbo].[TRiskProfileCombined] ([AtrTemplateGuid]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TRiskProfileCombined] ON [dbo].[TRiskProfileCombined] ([IndigoClientGuid]) WITH (FILLFACTOR=80)
GO
