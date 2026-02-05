CREATE TABLE [dbo].[TExpenditureChange]
(
[ExpenditureChangeId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TExpenditureChange_ConcurrencyId] DEFAULT ((1)),
[CRMContactId] [int] NOT NULL,
[CRMContactId2] [int] NULL,
[IsRise] [bit] NOT NULL,
[Amount] [money] NOT NULL,
[Frequency] [varchar] (16) NOT NULL,
[StartDate] [date] NULL,
[Description] [varchar] (3000) NULL
)
GO
ALTER TABLE [dbo].[TExpenditureChange] ADD CONSTRAINT [PK_TExpenditureChange] PRIMARY KEY NONCLUSTERED  ([ExpenditureChangeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TExpenditureChange_CRMContactId] ON [dbo].[TExpenditureChange] ([CRMContactId])
CREATE NONCLUSTERED INDEX [IDX_TExpenditureChange_CRMContactId2] ON [dbo].[TExpenditureChange] ([CRMContactId2])
GO
