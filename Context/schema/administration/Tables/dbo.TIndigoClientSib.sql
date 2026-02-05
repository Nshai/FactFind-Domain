CREATE TABLE [dbo].[TIndigoClientSib]
(
[IndigoClientSibId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[GroupId] [int] NULL,
[Sib] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[IsAgencyCode] [bit] NOT NULL CONSTRAINT [DF_TIndigoClientSib_IsAgencyCode] DEFAULT ((0)),
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TIndigoClientSib_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIndigoClientSib_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TIndigoClientSib] ADD CONSTRAINT [PK_TIndigoClientSib] PRIMARY KEY NONCLUSTERED  ([IndigoClientSibId]) WITH (FILLFACTOR=80)
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_TIndigoClientSib_Sib] ON [dbo].[TIndigoClientSib] ([Sib])
GO
