CREATE TABLE [dbo].[TRefFundAttributeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AttributeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[AttributeCode] [varchar] (25) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefFundAttributeAudit_ConcurrencyId] DEFAULT ((1)),
[RefFundAttributeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefFundAttributeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[AttributeBit] [int] NULL
)
GO
ALTER TABLE [dbo].[TRefFundAttributeAudit] ADD CONSTRAINT [PK_TRefFundAttributeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
