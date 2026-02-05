CREATE TABLE [dbo].[TEmploymentHistoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Employer] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[GrossAnnualEarnings] [money] NULL,
[ConcurrencyId] [int] NOT NULL,
[EmploymentHistoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEmploymentHistoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsCurrentEmployment] [bit] NULL,
[EmploymentDetailId] [int] NULL
)
GO
ALTER TABLE [dbo].[TEmploymentHistoryAudit] ADD CONSTRAINT [PK_TEmploymentHistoryAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TEmploymentHistoryAudit_EmploymentHistoryId_ConcurrencyId] ON [dbo].[TEmploymentHistoryAudit] ([EmploymentHistoryId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
