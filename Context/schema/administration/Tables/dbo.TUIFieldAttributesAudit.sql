CREATE TABLE [dbo].[TUIFieldAttributesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UIFieldAttributesId] [int] NOT NULL,
[UIFieldNameId] [int] NULL,
[AttributesName] [varchar](100) NULL,
[AttributesValue] [varchar](100) NULL,
[TenantId] [int] NULL,
[ConcurrencyId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO