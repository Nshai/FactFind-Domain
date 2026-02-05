CREATE TABLE [dbo].[TDirectorSharesInfo]
(
[DirectorSharesInfoId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[AgreementForSharesYesNo] [bit] NULL,
[AgreementForSharesType] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[PowerToPurchaseSharesYesNo] [bit] NULL,
[notes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TDirectorSharesInfo__ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TDirectorSharesInfo_CRMContactId] ON [dbo].[TDirectorSharesInfo] ([CRMContactId])
GO
