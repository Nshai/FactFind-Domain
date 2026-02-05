CREATE TABLE [dbo].[TRefPriority]
(
[RefPriorityId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PriorityName] [varchar] (255) NOT NULL,
[IndClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPriority_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefPriority] ADD CONSTRAINT [PK_TRefPriority_RefPriorityId] PRIMARY KEY CLUSTERED  ([RefPriorityId])
GO
CREATE NONCLUSTERED INDEX IDX_TRefPriority_IndClientId ON [dbo].[TRefPriority] ([IndClientId])
GO