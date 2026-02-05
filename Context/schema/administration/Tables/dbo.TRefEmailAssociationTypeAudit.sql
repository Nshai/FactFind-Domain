CREATE TABLE [dbo].[TRefEmailAssociationTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AssociationTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefEmailAssociationTypeAudit_ConcurrencyId] DEFAULT ((1)),
[RefEmailAssociationTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefEmailAssociationTypeAudit] ADD CONSTRAINT [PK_TRefEmailAssociationTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
