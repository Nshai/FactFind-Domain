CREATE TABLE [dbo].[TInterests]
(
[InterestsId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[RefInterestId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TInterests_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TInterests] ADD CONSTRAINT [PK_TInterests] PRIMARY KEY NONCLUSTERED  ([InterestsId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TInterests_CRMCOntactId] ON [dbo].[TInterests] ([CRMContactId]) with (sort_in_tempdb = on)
GO