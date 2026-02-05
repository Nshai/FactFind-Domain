CREATE TABLE [dbo].[TSavings]
(
[SavingsId] [int] NOT NULL IDENTITY(1, 1),
[Type] [varchar] (16)  NOT NULL,
[Description] [varchar] (128)  NOT NULL,
[Amount] [money] NOT NULL,
[Income] [money] NULL,
[PurchasedOn] [datetime] NULL,
[IsJoint] [bit] NULL,
[CrmContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSavings_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TSavings] ADD CONSTRAINT [PK_TSavings_SavingsId] PRIMARY KEY CLUSTERED  ([SavingsId])
GO
ALTER TABLE [dbo].[TSavings] WITH CHECK ADD CONSTRAINT [FK_TSavings_CrmContactId_CrmContactId] FOREIGN KEY ([CrmContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
