CREATE TABLE [dbo].[TYourexpendituresummary]
(
[YourexpendituresummaryId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Description] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Amount] [money] NULL,
[Frequency] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Owner] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TYourexpe__Concu__0EAE1DE1] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TYourexpendituresummary_CRMContactId] ON [dbo].[TYourexpendituresummary] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
