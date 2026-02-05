CREATE TABLE [dbo].[TDefaultPercentage]
(
[DefaultPercentageId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[Percentage] [decimal] (10, 2) NULL,
[GroupingId] [int] NULL,
[PaymentEntityId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDefaultPercentage_ConcurrencyId] DEFAULT ((1))
)
GO
