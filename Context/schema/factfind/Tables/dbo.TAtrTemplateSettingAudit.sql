CREATE TABLE [dbo].[TAtrTemplateSettingAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AtrTemplateId] [int] NOT NULL,
[AtrRefProfilePreferenceId] [int] NOT NULL,
[OverrideProfile] [int] NULL,
[LossAndGain] [int] NULL,
[AssetAllocation] [int] NULL,
[CostOfDelay] [int] NULL,
[Report] [int] NULL,
[AutoCreateOpportunities] [int] NULL,
[ReportLabel] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[AtrTemplateSettingId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrTemplateSettingAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrTemplateSettingAudit] ADD CONSTRAINT [PK_TAtrTemplateSettingAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrTemplateSettingAudit_AtrTemplateSettingId_ConcurrencyId] ON [dbo].[TAtrTemplateSettingAudit] ([AtrTemplateSettingId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
