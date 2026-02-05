CREATE TABLE [dbo].[TTenantEmailAssociationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EmailAssociationTypeId] [int] NOT NULL,
[TenantEmailConfigId] [int] NOT NULL,
[IsActive] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTenantEmailAssociationAudit_ConcurrencyId] DEFAULT ((1)),
[TenantEmailAssociationId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TTenantEmailAssociationAudit] ADD CONSTRAINT [PK_TTenantEmailAssociationAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
