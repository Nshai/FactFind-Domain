CREATE TABLE [dbo].[THealth]
(
[HealthId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[GoodHealth] [bit] NULL,
[HealthComments] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__THealth__Concurr__75E27017] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[THealth] ADD CONSTRAINT [PK_THealth] PRIMARY KEY CLUSTERED  ([HealthId])
GO
CREATE NONCLUSTERED INDEX [IDX_THealth_CRMContactId] ON [dbo].[THealth] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_THealth_CRMContactId] ON [dbo].[THealth] ([CRMContactId])
GO
