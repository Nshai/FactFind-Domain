CREATE TABLE [dbo].[TRefFeeStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefFeeStatusId] [int] NOT NULL,
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefFeeStatusAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefFeeStatusAudit] ADD CONSTRAINT [PK_TRefFeeStatusAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
