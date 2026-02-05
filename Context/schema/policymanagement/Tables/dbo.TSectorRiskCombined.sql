CREATE TABLE [dbo].[TSectorRiskCombined]
(
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TSectorRiskCombined_Guid] DEFAULT (newid()),
[SectorRiskId] [int] NOT NULL,
[CategoryId] [int] NOT NULL,
[FundTypeId] [int] NOT NULL,
[RiskProfileId] [int] NOT NULL,
[RiskProfileGuid] [uniqueidentifier] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_685E403A_F138_4B5D_B2B1_98572B0713F9_645121589] DEFAULT (newid())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TSectorRiskCombined_5] on [dbo].[TSectorRiskCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TSectorRiskCombined] set msrepl_tran_version = newid() from [dbo].[TSectorRiskCombined], inserted  
     where      [dbo].[TSectorRiskCombined].[Guid] = inserted.[Guid] 
 
GO
EXEC sp_settriggerorder N'[dbo].[sp_MSsync_upd_trig_TSectorRiskCombined_5]', 'first', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TSectorRiskCombined_6] on [dbo].[TSectorRiskCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TSectorRiskCombined] set msrepl_tran_version = newid() from [dbo].[TSectorRiskCombined], inserted  
     where      [dbo].[TSectorRiskCombined].[Guid] = inserted.[Guid] 
 
GO
ALTER TABLE [dbo].[TSectorRiskCombined] ADD CONSTRAINT [PK_TSectorRiskCombined] PRIMARY KEY NONCLUSTERED  ([Guid]) WITH (FILLFACTOR=80)
GO
