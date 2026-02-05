CREATE TABLE [dbo].[TValLookUpAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefProdProviderId] [int] NOT NULL,
[MappedRefProdProviderId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[ValLookUpId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValLookUpAudit] ADD CONSTRAINT [PK_TValLookUpAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
