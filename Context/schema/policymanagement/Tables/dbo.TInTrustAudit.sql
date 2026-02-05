CREATE TABLE [dbo].[TInTrustAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ToWhom] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[InTrustFG] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[InTrustId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TInTrustAudit] ADD CONSTRAINT [PK_TInTrustAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TInTrustAudit_InTrustId_ConcurrencyId] ON [dbo].[TInTrustAudit] ([InTrustId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
