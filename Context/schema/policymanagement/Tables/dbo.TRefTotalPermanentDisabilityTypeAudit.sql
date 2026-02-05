CREATE TABLE [dbo].[TRefTotalPermanentDisabilityTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefTotalPermanentDisabilityTypeAudit_ConcurrencyId] DEFAULT ((1)),
[RefTotalPermanentDisabilityTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefTotalPermanentDisabilityTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefTotalPermanentDisabilityTypeAudit] ADD CONSTRAINT [PK_TRefTotalPermanentDisabilityTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
