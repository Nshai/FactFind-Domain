CREATE TABLE [dbo].[TRefPaymentOn]
(
[RefPaymentOnId] [int] NOT NULL IDENTITY(1, 1),
[Descriptor] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFG] [bit] NOT NULL,
[IndigoClientId] [int] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
