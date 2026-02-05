CREATE TABLE [dbo].[TBankDetail]
(
[BankDetailId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[CRMOwnerId] [int] NOT NULL,
[SortCode] [varchar] (50)  NOT NULL,
[AccName] [varchar] (50)  NOT NULL,
[AccNumber] [varchar] (50)  NOT NULL,
[CorporateId] [int] NULL,
[CRMBranchId] [int] NULL,
[RefAccTypeId] [int] NULL,
[RefAccUseId] [int] NULL,
[AccBalance] [money] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TBankDetail_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TBankDetail] ADD CONSTRAINT [PK_TBankDetail] PRIMARY KEY NONCLUSTERED  ([BankDetailId])
GO
CREATE NONCLUSTERED INDEX [IDX_TBankDetail_CorporateId] ON [dbo].[TBankDetail] ([CorporateId])
GO
CREATE NONCLUSTERED INDEX [IDX_TBankDetail_CRMOwnerId] ON [dbo].[TBankDetail] ([CRMOwnerId])
GO
CREATE NONCLUSTERED INDEX [IDX_TBankDetail_RefAccTypeId] ON [dbo].[TBankDetail] ([RefAccTypeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TBankDetail_RefAccUseId] ON [dbo].[TBankDetail] ([RefAccUseId])
GO
ALTER TABLE [dbo].[TBankDetail] WITH CHECK ADD CONSTRAINT [FK_TBankDetail_CorporateId_CorporateId] FOREIGN KEY ([CorporateId]) REFERENCES [dbo].[TCorporate] ([CorporateId])
GO
ALTER TABLE [dbo].[TBankDetail] WITH CHECK ADD CONSTRAINT [FK_TBankDetail_CRMOwnerId_CRMContactId] FOREIGN KEY ([CRMOwnerId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
ALTER TABLE [dbo].[TBankDetail] ADD CONSTRAINT [FK_TBankDetail_RefAccTypeId_RefAccTypeId] FOREIGN KEY ([RefAccTypeId]) REFERENCES [dbo].[TRefAccType] ([RefAccTypeId])
GO
ALTER TABLE [dbo].[TBankDetail] ADD CONSTRAINT [FK_TBankDetail_RefAccUseId_RefAccUseId] FOREIGN KEY ([RefAccUseId]) REFERENCES [dbo].[TRefAccUse] ([RefAccUseId])
GO
