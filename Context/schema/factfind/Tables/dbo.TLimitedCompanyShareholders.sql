CREATE TABLE [dbo].[TLimitedCompanyShareholders]
(
[LimitedCompanyShareholdersId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ShareHolderName] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ShareHolderRole] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[DOB] [datetime] NULL,
[Smoker] [bit] NULL,
[DateJoinedCompany] [datetime] NULL,
[CurrentValue] [money] NULL,
[PercentageInterest] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[CurrentYear] [money] NULL,
[LastYear] [money] NULL,
[TwoYearsAgo] [money] NULL,
[InGoodHealth] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TLimitedCompanyShareholders__ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TLimitedCompanyShareholders_CRMContactId] ON [dbo].[TLimitedCompanyShareholders] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
