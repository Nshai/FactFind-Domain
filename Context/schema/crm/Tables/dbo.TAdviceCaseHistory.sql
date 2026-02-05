CREATE TABLE [dbo].[TAdviceCaseHistory]
(
[AdviceCaseHistoryId] [int] NOT NULL IDENTITY(1, 1),
[AdviceCaseId] [int] NOT NULL,
[ChangeType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[StatusId] [int] NULL,
[PractitionerId] [int] NULL,
[ChangedByUserId] [int] NULL,
[StatusDate] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseHistory_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdviceCaseHistory] ADD CONSTRAINT [PK_TAdviceCaseHistory] PRIMARY KEY NONCLUSTERED  ([AdviceCaseHistoryId])
GO
CREATE NONCLUSTERED INDEX [IX_TAdviceCaseHistory_AdviceCaseId] ON [dbo].[TAdviceCaseHistory] ([AdviceCaseId])
GO