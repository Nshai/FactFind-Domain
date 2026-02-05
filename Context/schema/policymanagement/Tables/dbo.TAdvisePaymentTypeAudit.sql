CREATE TABLE [dbo].[TAdvisePaymentTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[TenantId] [int] NOT NULL,
[IsArchived] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[AdvisePaymentTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Name] [nvarchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[IsSystemDefined] [bit] NOT NULL CONSTRAINT [DF__TAdvisePa__IsSys__436E60E8] DEFAULT ((0)),
[GroupId] [int] NULL,
[RefAdvisePaidById] [int] NULL,
[PaymentProviderId] [int] NULL
)
GO
ALTER TABLE [dbo].[TAdvisePaymentTypeAudit] ADD CONSTRAINT [PK_TAdvisePaymentTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
