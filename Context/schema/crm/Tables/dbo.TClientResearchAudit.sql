CREATE TABLE [dbo].[TClientResearchAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CalculatorId] [int] NOT NULL,
[CRMContactId] [int] NULL,
[UserId] [int] NOT NULL,
[Date] [datetime] NOT NULL CONSTRAINT [DF_TClientResearchAudit_Date] DEFAULT (getdate()),
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TClientResearchAudit_ConcurrencyId] DEFAULT ((1)),
[ClientResearchId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TClientResearchAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TClientResearchAudit] ADD CONSTRAINT [PK_TClientResearchAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
