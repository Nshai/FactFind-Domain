CREATE TABLE [dbo].[TDebtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ChargesYN] [bit] NULL,
[ChargesDetails] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[ComfortExtracCash] [money] NULL,
[CRMContactId] [int] NOT NULL,
[DebtId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TDebtAudi__Concu__607D3EDD] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDebtAudit] ADD CONSTRAINT [PK_TDebtAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
