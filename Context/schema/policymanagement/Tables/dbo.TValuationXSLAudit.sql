CREATE TABLE [dbo].[TValuationXSLAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (500) COLLATE Latin1_General_CI_AS NULL,
[XSL] [varchar] (7000) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValuationXSLAudit_ConcurrencyId] DEFAULT ((1)),
[ValuationXSLId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TValuationXSLAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValuationXSLAudit] ADD CONSTRAINT [PK_TValuationXSLAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
