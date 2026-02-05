CREATE TABLE [dbo].[TRefInsuranceCoverCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefInsuranceCoverCategoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefInsuranceCoverCategoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefInsuranceCoverCategoryAudit] ADD CONSTRAINT [PK_TRefInsuranceCoverCategoryAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
