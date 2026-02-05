CREATE TABLE [dbo].[TMortgageMiscellaneousAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NULL,
[CRMContactId] [int] NULL,
[HasExistingProvision] [bit] NULL,
[HasAdverseCreditHistory] [bit] NULL,
[NumberOfExistingMortgages] [int] NULL,
[Notes] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[MortgageMiscellaneousId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TMortgageMiscellaneousAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[HasRefusedCredit] [bit] NULL,
[RefusedCredit] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[HasEquityRelease] [bit] NULL
)
GO
ALTER TABLE [dbo].[TMortgageMiscellaneousAudit] ADD CONSTRAINT [PK_TMortgageMiscellaneousAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TMortgageMiscellaneousAudit_MortgageMiscellaneousId_ConcurrencyId] ON [dbo].[TMortgageMiscellaneousAudit] ([MortgageMiscellaneousId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
