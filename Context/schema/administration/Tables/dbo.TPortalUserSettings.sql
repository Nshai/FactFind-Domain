CREATE TABLE [dbo].[TPortalUserSettings]
(
[PortalUserSettingsId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IndigoClientId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[UserId] [int] NULL,
[EnablePortalFg] [bit] NOT NULL CONSTRAINT [DF_TPortalUserSettings_EnablePortalFg] DEFAULT ((0)),
[SendEmailNotificationFg] [bit] NOT NULL CONSTRAINT [DF_TPortalUserSettings_SendEmailNotificationFg] DEFAULT ((0)),
[AccountLockedFg] [bit] NOT NULL CONSTRAINT [DF_TPortalUserSettings_AccountLockedFg] DEFAULT ((0)),
[AllowFactFindFg] [bit] NOT NULL CONSTRAINT [DF_TPortalUserSettings_AllowFactFindFg] DEFAULT ((1)),
[AllowValuationsFg] [bit] NOT NULL CONSTRAINT [DF_TPortalUserSettings_AllowValuationsFg] DEFAULT ((1)),
[AllowPortfolioReportFg] [bit] NOT NULL CONSTRAINT [DF_TPortalUserSettings_AllowPortfolioReportFg] DEFAULT ((1)),
[AllowFPRetirementFg] [bit] NOT NULL CONSTRAINT [DF_TPortalUserSettings_AllowFPRetirementFg] DEFAULT ((1)),
[AllowFPMortgageFg] [bit] NOT NULL CONSTRAINT [DF_TPortalUserSettings_AllowFPMortgageFg] DEFAULT ((1)),
[AllowFPInvestmentFg] [bit] NOT NULL CONSTRAINT [DF_TPortalUserSettings_AllowFPInvestmentFg] DEFAULT ((1)),
[AllowFPBudgetFg] [bit] NOT NULL CONSTRAINT [DF_TPortalUserSettings_AllowFPBudgetFg] DEFAULT ((1)),
[AllowFPProtectionFg] [bit] NOT NULL CONSTRAINT [DF_TPortalUserSettings_AllowFPProtectionFg] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPortalUserSettings_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPortalUserSettings] ADD CONSTRAINT [PK_TPortalUserSettings] PRIMARY KEY NONCLUSTERED  ([PortalUserSettingsId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPortalUserSettings_CRMContactId] ON [dbo].[TPortalUserSettings] ([CRMContactId]) WITH (FILLFACTOR=80)
GO