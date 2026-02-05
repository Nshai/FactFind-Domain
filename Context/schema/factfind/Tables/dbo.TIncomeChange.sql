CREATE TABLE [dbo].[TIncomeChange]
(
[IncomeChangeId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIncomeChange_ConcurrencyId] DEFAULT ((1)),
[CRMContactId] [int] NOT NULL,
[CRMContactId2] [int] NULL,
[IsRise] [bit] NOT NULL,
[Amount] [money] NULL,
[Frequency] [varchar] (16) NOT NULL,
[StartDate] [date] NULL,
[Description] [varchar] (255) NULL,
[IsOwnerSelected] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TIncomeChange] ADD CONSTRAINT [PK_TIncomeChange] PRIMARY KEY NONCLUSTERED  ([IncomeChangeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TIncomeChange_CRMContactId] ON [dbo].[TIncomeChange] ([CRMContactId])
GO
