CREATE TABLE [dbo].[TIndigoClientPreference]
(
[IndigoClientPreferenceId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[PreferenceName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Value] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Disabled] [bit] NOT NULL CONSTRAINT [DF_TIndigoClientPreference_Enabled] DEFAULT ((0)),
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TIndigoClientPreference_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIndigoClientPreference_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TIndigoClientPreference] ADD CONSTRAINT [PK_TIndigoClientPreference] PRIMARY KEY CLUSTERED  ([IndigoClientPreferenceId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TIndigoClientPreference_IndigoClientGuid_PreferanceName] ON [dbo].[TIndigoClientPreference] ([IndigoClientGuid], [PreferenceName])
GO
CREATE NONCLUSTERED INDEX [IX_TDocumentTypeCombined_IndigoClientGuid_PreferenceName_Value] ON [dbo].[TIndigoClientPreference] ([IndigoClientGuid], [PreferenceName], [Value])
GO
CREATE NONCLUSTERED INDEX IX_TIndigoClientPreference_IndigoClientId ON [dbo].[TIndigoClientPreference] ([IndigoClientId]) 
GO
CREATE NONCLUSTERED INDEX IX_TIndigoClientPreference_IndigoClientId_PreferenceName ON [dbo].[TIndigoClientPreference] ([IndigoClientId],[PreferenceName]) 
GO
CREATE NONCLUSTERED INDEX IX_TIndigoClientPreference_PreferenceName_Value_Disabled ON [dbo].[TIndigoClientPreference] ([PreferenceName],[Value],[Disabled])
GO