CREATE TABLE [dbo].[TPortalUserSettingsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IndigoClientId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[UserId] [int] NULL,
[EnablePortalFg] [bit] NOT NULL CONSTRAINT [DF_TPortalUserSettingsAudit_EnablePortalFg] DEFAULT ((0)),
[SendEmailNotificationFg] [bit] NOT NULL CONSTRAINT [DF_TPortalUserSettingsAudit_SendEmailNotificationFg] DEFAULT ((0)),
[AccountLockedFg] [bit] NOT NULL CONSTRAINT [DF_TPortalUserSettingsAudit_AccountLockedFg] DEFAULT ((0)),
[AllowFactFindFg] [bit] NOT NULL CONSTRAINT [DF_TPortalUserSettingsAudit_AllowFactFindFg] DEFAULT ((1)),
[AllowValuationsFg] [bit] NOT NULL CONSTRAINT [DF_TPortalUserSettingsAudit_AllowValuationsFg] DEFAULT ((1)),
[AllowPortfolioReportFg] [bit] NOT NULL CONSTRAINT [DF_TPortalUserSettingsAudit_AllowPortfolioReportFg] DEFAULT ((1)),
[AllowFPRetirementFg] [bit] NOT NULL CONSTRAINT [DF_TPortalUserSettingsAudit_AllowFPRetirementFg] DEFAULT ((1)),
[AllowFPMortgageFg] [bit] NOT NULL CONSTRAINT [DF_TPortalUserSettingsAudit_AllowFPMortgageFg] DEFAULT ((1)),
[AllowFPInvestmentFg] [bit] NOT NULL CONSTRAINT [DF_TPortalUserSettingsAudit_AllowFPInvestmentFg] DEFAULT ((1)),
[AllowFPBudgetFg] [bit] NOT NULL CONSTRAINT [DF_TPortalUserSettingsAudit_AllowFPBudgetFg] DEFAULT ((1)),
[AllowFPProtectionFg] [bit] NOT NULL CONSTRAINT [DF_TPortalUserSettingsAudit_AllowFPProtectionFg] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPortalUserSettingsAudit_ConcurrencyId] DEFAULT ((1)),
[PortalUserSettingsId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPortalUserSettingsAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPortalUserSettingsAudit] ADD CONSTRAINT [PK_TPortalUserSettingsAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPortalUserSettingsAudit_PortalUserSettingsId_ConcurrencyId] ON [dbo].[TPortalUserSettingsAudit] ([PortalUserSettingsId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
