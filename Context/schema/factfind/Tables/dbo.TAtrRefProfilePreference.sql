CREATE TABLE [dbo].[TAtrRefProfilePreference]
(
[AtrRefProfilePreferenceId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Descriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrRefProfilePreference_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAtrRefProfilePreference] ADD CONSTRAINT [PK_TAtrRefProfilePreference] PRIMARY KEY NONCLUSTERED  ([AtrRefProfilePreferenceId]) WITH (FILLFACTOR=80)
GO
