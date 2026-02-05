CREATE TABLE [dbo].[TCoverBasisAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[BasisType] [int] NULL,
[CriticalIllnessDetailId] [int] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[CoverBasisId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TCoverBasisAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCoverBasisAudit] ADD CONSTRAINT [PK_TCoverBasisAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
