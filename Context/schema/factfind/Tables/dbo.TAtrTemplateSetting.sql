CREATE TABLE [dbo].[TAtrTemplateSetting]
(
[AtrTemplateSettingId] [int] NOT NULL IDENTITY(1, 1),
[AtrTemplateId] [int] NOT NULL,
[AtrRefProfilePreferenceId] [int] NOT NULL,
[OverrideProfile] [int] NULL CONSTRAINT [DF_TAtrTemplateSetting_OverrideProfile] DEFAULT ((1)),
[LossAndGain] [int] NULL CONSTRAINT [DF_TAtrTemplateSetting_LossAndGain] DEFAULT ((1)),
[AssetAllocation] [int] NULL CONSTRAINT [DF_TAtrTemplateSetting_AssetAllocation] DEFAULT ((1)),
[CostOfDelay] [int] NULL CONSTRAINT [DF_TAtrTemplateSetting_CostOfDelay] DEFAULT ((1)),
[Report] [int] NULL CONSTRAINT [DF_TAtrTemplateSetting_Report] DEFAULT ((1)),
[AutoCreateOpportunities] [int] NULL CONSTRAINT [DF_TAtrTemplateSetting_AutoCreateOpportunities] DEFAULT ((1)),
[ReportLabel] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrTemplateSetting_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAtrTemplateSetting] ADD CONSTRAINT [PK_TAtrTemplateSetting] PRIMARY KEY NONCLUSTERED  ([AtrTemplateSettingId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX IX_TAtrTemplateSetting_AtrTemplateId ON [dbo].[TAtrTemplateSetting] ([AtrTemplateId]) 
GO
CREATE NONCLUSTERED INDEX IX_INCL_TAtrTemplateSetting_AtrTemplateId ON [dbo].[TAtrTemplateSetting] ([AtrTemplateId]) INCLUDE ([AtrTemplateSettingId],[AtrRefProfilePreferenceId],[OverrideProfile],[LossAndGain],[AssetAllocation],[CostOfDelay],[Report],[AutoCreateOpportunities],[ConcurrencyId]) 
GO