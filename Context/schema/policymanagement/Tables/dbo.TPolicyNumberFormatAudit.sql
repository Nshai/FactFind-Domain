CREATE TABLE [dbo].[TPolicyNumberFormatAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UserFormat] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[Example] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[RegularExpression] [varchar] (1000) COLLATE Latin1_General_CI_AS NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[RefPlanTypeId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[PolicyNumberFormatId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPolicyNumberFormatAudit] ADD CONSTRAINT [PK_TPolicyNumberFormatAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
