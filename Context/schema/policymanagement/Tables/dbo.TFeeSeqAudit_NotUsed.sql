CREATE TABLE [dbo].[TFeeSeqAudit_NotUsed]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[IndigoClientCode] [char] (3) COLLATE Latin1_General_CI_AS NULL,
[MaxSequence] [int] NULL CONSTRAINT [DF_TFeeSeqAud_MaxSequence_2__56] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFeeSeqAud_ConcurrencyId_1__56] DEFAULT ((1)),
[FeeSeqId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFeeSeqAud_StampDateTime_3__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFeeSeqAudit_NotUsed] ADD CONSTRAINT [PK_TFeeSeqAudit_4__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TFeeSeqAudit_FeeSeqId_ConcurrencyId] ON [dbo].[TFeeSeqAudit_NotUsed] ([FeeSeqId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
