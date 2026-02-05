CREATE TABLE [dbo].[TRefFeeTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[FeeTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RefVATId] [int] NULL,
[FeeFg] [bit] NULL CONSTRAINT [DF_TRefFeeTyp_FeeFg_2__56] DEFAULT ((0)),
[RetainerFg] [bit] NULL CONSTRAINT [DF_TRefFeeTyp_RetainerFg_3__56] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TRefFeeTyp_ConcurrencyId_1__56] DEFAULT ((1)),
[RefFeeTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefFeeTyp_StampDateTime_4__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefFeeTypeAudit] ADD CONSTRAINT [PK_TRefFeeTypeAudit_5__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefFeeTypeAudit_RefFeeTypeId_ConcurrencyId] ON [dbo].[TRefFeeTypeAudit] ([RefFeeTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
