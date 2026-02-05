CREATE TABLE [dbo].[TFeeInstalmentAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FeeId] [int] NOT NULL,
[NextInstalmentDate] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[InstalmentCount] [int] NOT NULL,
[FeeInstalmentId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFeeInstalmentAudit] ADD CONSTRAINT [PK_TFeeInstalmentAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
