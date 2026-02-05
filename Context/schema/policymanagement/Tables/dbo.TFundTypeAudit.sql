CREATE TABLE [dbo].[TFundTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Abbreviation] [varchar] (5) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFundTypeAudit_ConcurrencyId] DEFAULT ((1)),
[FundTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFundTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFundTypeAudit] ADD CONSTRAINT [PK_TFundTypeAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
