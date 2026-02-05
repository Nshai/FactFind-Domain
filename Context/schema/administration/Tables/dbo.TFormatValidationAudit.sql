CREATE TABLE [dbo].[TFormatValidationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[Entity] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RuleType] [int] NOT NULL,
[ValidationExpression] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[ErrorMessage] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[FormatValidationId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFormatValidationAudit] ADD CONSTRAINT [PK_TFormatValidationAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
