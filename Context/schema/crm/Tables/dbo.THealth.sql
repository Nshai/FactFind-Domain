CREATE TABLE [dbo].[THealth]
(
[HealthId] [int] NOT NULL IDENTITY(1, 1),
[Comment] [varchar] (128)  NULL,
[CrmContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_THealth_Concurrency] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[THealth] ADD CONSTRAINT [PK_THealth] PRIMARY KEY CLUSTERED  ([HealthId])
GO
ALTER TABLE [dbo].[THealth] WITH CHECK ADD CONSTRAINT [FK_THealth_CrmContactId_CrmContactId] FOREIGN KEY ([CrmContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
