CREATE TABLE [dbo].[TRepossession]
(
[RepossessionId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[repDate] [datetime] NULL,
[repLenderName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[repDebt] [bit] NULL,
[repApp1] [bit] NULL,
[repApp2] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRepossession_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRepossession] ADD CONSTRAINT [PK_TRepossession] PRIMARY KEY NONCLUSTERED  ([RepossessionId]) WITH (FILLFACTOR=80)
GO
