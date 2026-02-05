CREATE TABLE [dbo].[TLeadStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Descriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[CanConvertToClientFG] [bit] NOT NULL,
[OrderNumber] [int] NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[LeadStatusId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RefServiceStatusId] [int] NULL
)
GO
ALTER TABLE [dbo].[TLeadStatusAudit] ADD CONSTRAINT [PK_TLeadStatusAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
