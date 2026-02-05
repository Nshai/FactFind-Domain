CREATE TABLE [dbo].[TCCJDefault]
(
[CCJDefaultId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ccjType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ccjDateReg] [datetime] NULL,
[ccjAmount] [decimal] (10, 2) NULL,
[ccjDateSatisf] [datetime] NULL,
[ccjApp1] [bit] NULL,
[ccjApp2] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCCJDefault_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TCCJDefault] ADD CONSTRAINT [PK_TCCJDefault] PRIMARY KEY NONCLUSTERED  ([CCJDefaultId]) WITH (FILLFACTOR=80)
GO
