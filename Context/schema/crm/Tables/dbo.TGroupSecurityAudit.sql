CREATE TABLE [dbo].[TGroupSecurityAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[GroupSecurityId] [int] NOT NULL,
[GroupId] [int] NOT NULL,
[IsActivityCategoryPropagationAllowed] [bit] NOT NULL,
[IsEventListPropagationAllowed] [bit] NOT NULL,
[IsFeeModelPropagationAllowed] [bit] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
