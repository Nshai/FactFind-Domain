CREATE TABLE [dbo].[TUIFieldNameAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UIFieldNameId] [int] NOT NULL,
[UIDomainId] [int] NULL,
[FieldName] [varchar](100) NULL,
[TenantId] [int] NULL,
[ConcurrencyId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO