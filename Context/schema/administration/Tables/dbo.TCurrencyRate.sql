CREATE TABLE [dbo].[TCurrencyRate]
(
[CurrencyRateId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IndigoClientId] [int] NOT NULL,
[CurrencyCode] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Rate] [money] NOT NULL,
[Date] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TCurrencyRate] ADD CONSTRAINT [PK_TCurrencyRate] PRIMARY KEY CLUSTERED  ([CurrencyRateId])
GO

CREATE NONCLUSTERED INDEX IX_TCurrencyRate_IndigoClientId_CurrencyCode   
	ON [dbo].[TCurrencyRate] (IndigoClientId, CurrencyCode) INCLUDE (Rate)
GO