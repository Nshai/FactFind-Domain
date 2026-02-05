CREATE TABLE [dbo].[TDomain]
(
[DomainId] [int] NOT NULL IDENTITY(1, 1),
[GroupId] [int] NOT NULL,
[Host] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Application] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TDomain] ADD CONSTRAINT [PK_TDomain] PRIMARY KEY CLUSTERED  ([DomainId])
GO
ALTER TABLE [dbo].[TDomain] ADD CONSTRAINT [UQ__TDomain__6D0E29E0FBFB6F58] UNIQUE NONCLUSTERED  ([Host])
GO
CREATE INDEX IX_TDomain_GroupId ON TDomain (GroupId)
