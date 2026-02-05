CREATE TABLE [dbo].[TAdditionalFeeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NULL,
[FeeType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PayableType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[FeeAmount] [money] NULL,
[PayableTo] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RefundableType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RefundableAmount] [money] NULL,
[CRMContactId] [int] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TAdditionalFeeAudit_ConcurrencyId] DEFAULT ((0)),
[AdditionalFeeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAdditionalFeeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdditionalFeeAudit] ADD CONSTRAINT [PK_TAdditionalFeeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAdditionalFeeAudit_AdditionalFeeId_ConcurrencyId] ON [dbo].[TAdditionalFeeAudit] ([AdditionalFeeId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
