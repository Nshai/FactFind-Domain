CREATE TABLE [dbo].[TInsuredItemAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[RefInsuredItemTypeId] [int] NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RefHomeContentCoverCategoryId] [int] NOT NULL,
[Value] [money] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[InsuredItemId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TInsuredItemAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TInsuredItemAudit] ADD CONSTRAINT [PK_TInsuredItemAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
