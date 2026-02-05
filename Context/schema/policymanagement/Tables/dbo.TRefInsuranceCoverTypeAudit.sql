CREATE TABLE [dbo].[TRefInsuranceCoverTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(0, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefInsuranceCoverTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefInsuranceCoverTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefInsuranceCoverTypeAudit] ADD CONSTRAINT [PK_TRefInsuranceCoverTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
