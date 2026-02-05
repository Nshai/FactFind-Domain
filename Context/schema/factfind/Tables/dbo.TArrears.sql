CREATE TABLE [dbo].[TArrears]
(
[ArrearsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[arrDateFirst] [datetime] NULL,
[arrMissedNo] [int] NULL,
[arrStillNo] [int] NULL,
[arrDateClear] [datetime] NULL,
[arrWillBeClearedFg] [bit] NULL,
[arrApp1] [bit] NULL,
[arrApp2] [bit] NULL,
[arrOutstanding] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TArrears_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TArrears] ADD CONSTRAINT [PK_TArrears] PRIMARY KEY NONCLUSTERED  ([ArrearsId]) WITH (FILLFACTOR=80)
GO
