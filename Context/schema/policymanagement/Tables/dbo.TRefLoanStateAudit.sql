CREATE TABLE [dbo].[TRefLoanStateAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[LoanStateName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OrigoRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefLoanStateId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefLoanSt_StampDateTime_1__52] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefLoanStateAudit] ADD CONSTRAINT [PK_TRefLoanStateAudit_2__52] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefLoanStateAudit_RefLoanStateId_ConcurrencyId] ON [dbo].[TRefLoanStateAudit] ([RefLoanStateId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
