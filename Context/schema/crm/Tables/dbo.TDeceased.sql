CREATE TABLE [dbo].[TDeceased]
(
[DeceasedId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[DeceasedFG] [bit] NOT NULL,
[DeceasedDate] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL,
[MigrationRef] [varchar] (255)
)
GO
ALTER TABLE [dbo].[TDeceased] ADD CONSTRAINT [PK_TDeceased] PRIMARY KEY CLUSTERED  ([DeceasedId])
GO
CREATE NONCLUSTERED INDEX [IDX_TDeceased_CRMContactId] ON [dbo].[TDeceased] ([CRMContactId])
GO
ALTER TABLE [dbo].[TDeceased] ADD CONSTRAINT [FK_TDeceased_TCRMContact] FOREIGN KEY ([CRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
create index IX_TDeceased_CRMContactId on TDeceased (CRMContactId)
go
create index IX_TDeceased_MigrationRef on TDeceased(MigrationRef) 
go 