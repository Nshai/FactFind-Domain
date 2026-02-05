CREATE TABLE [dbo].[TRefInsuranceCoverOptionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FlagValue] [int] NOT NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefInsuranceCoverOptionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefInsuranceCoverOptionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefInsuranceCoverOptionAudit] ADD CONSTRAINT [PK_TRefInsuranceCoverOptionAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
