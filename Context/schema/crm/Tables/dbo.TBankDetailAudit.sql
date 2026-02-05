CREATE TABLE [dbo].[TBankDetailAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IndClientId] [int] NOT NULL,
[CRMOwnerId] [int] NOT NULL,
[SortCode] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[AccName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[AccNumber] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[CorporateId] [int] NULL,
[CRMBranchId] [int] NULL,
[RefAccTypeId] [int] NULL,
[RefAccUseId] [int] NULL,
[AccBalance] [money] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[BankDetailId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TBankDetai_StampDateTime_1__54] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TBankDetailAudit] ADD CONSTRAINT [PK_TBankDetailAudit_2__54] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TBankDetailAudit_BankDetailId_ConcurrencyId] ON [dbo].[TBankDetailAudit] ([BankDetailId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
