CREATE TABLE [dbo].[TLegalEntityPreference]
(
[LegalEntityPreferenceId] [int] NOT NULL IDENTITY(1, 1),
[GroupId] [int] NOT NULL,
[PreferenceName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[PreferenceValue] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLegalEntityPreference_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TLegalEntityPreference] ADD CONSTRAINT [PK_TLegalEntityPreference] PRIMARY KEY NONCLUSTERED  ([LegalEntityPreferenceId])
GO
