CREATE TABLE [dbo].[TRiskProfileTemplateCombined]
(
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TRiskProfileTemplateCombined_Guid] DEFAULT (newid()),
[RiskProfileTemplateId] [int] NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[TenantId] [int] NOT NULL,
[TenantGuid] [uniqueidentifier] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRiskProfileTemplateCombined_ConcurrencyId] DEFAULT ((1)),
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_6661A821_CAB0_43CF_8393_1BCFC39074B0_501069021] DEFAULT (newid())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TRiskProfileTemplateCombined_4] on [dbo].[TRiskProfileTemplateCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TRiskProfileTemplateCombined] set msrepl_tran_version = newid() from [dbo].[TRiskProfileTemplateCombined], inserted  
     where      [dbo].[TRiskProfileTemplateCombined].[Guid] = inserted.[Guid] 
 
GO
EXEC sp_settriggerorder N'[dbo].[sp_MSsync_upd_trig_TRiskProfileTemplateCombined_4]', 'first', 'update', null
GO
ALTER TABLE [dbo].[TRiskProfileTemplateCombined] ADD CONSTRAINT [PK_TRiskProfileTemplateCombined] PRIMARY KEY CLUSTERED  ([Guid])
GO
