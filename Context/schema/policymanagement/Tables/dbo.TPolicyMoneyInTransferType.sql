CREATE TABLE [dbo].[TPolicyMoneyInTransferType]
(
[PolicyMoneyInTransferTypeId] [int] NOT NULL IDENTITY(1, 1),
[PolicyMoneyInId] [int] NOT NULL,
[TransferTypeId] [tinyint] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TPolicyMoneyInTransferType] ADD CONSTRAINT [PK_TPolicyMoneyInTransferType] PRIMARY KEY CLUSTERED  ([PolicyMoneyInTransferTypeId])
GO
