CREATE TABLE [dbo].[TYourexpendituredetails]
(
[YourexpendituredetailsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[CRMContactId2] [int] NULL,
[Amount] [money] NULL,
[Frequency] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Owner] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Description] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TYourExpenditureDetails_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TYourexpendituredetails] ADD CONSTRAINT [PK_TYourexpendituredetails] PRIMARY KEY NONCLUSTERED  ([YourexpendituredetailsId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TYourexpendituredetails_CRMContactId] ON [dbo].[TYourexpendituredetails] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IX_TYourexpendituredetails_CRMContactId] ON [dbo].[TYourexpendituredetails] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
