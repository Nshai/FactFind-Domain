CREATE TABLE [dbo].[TRefEvalueIncreaseTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IncreaseType] [varchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[RefEvalueIncreaseTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
