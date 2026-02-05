CREATE TABLE [dbo].[TRefCommissionTypeToPaymentDueType]
(
[RefCommissionTypeToPaymentDueTypeId] [int] NOT NULL IDENTITY(1, 1),
[RefCommissionTypeId] [int] NOT NULL,
[RefPaymentDueTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefCommissionTypeToPaymentDueType] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefCommissionTypeToPaymentDueType] ADD CONSTRAINT [PK_RefCommissionTypeToPaymentDueType] PRIMARY KEY CLUSTERED  ([RefCommissionTypeToPaymentDueTypeId])
GO
ALTER TABLE [dbo].[TRefCommissionTypeToPaymentDueType] ADD CONSTRAINT [FK_TRefCommissionTypeToPaymentDueTypeId_TRefCommissionType] FOREIGN KEY ([RefCommissionTypeId]) REFERENCES [dbo].[TRefCommissionType] ([RefCommissionTypeId])
GO
ALTER TABLE [dbo].[TRefCommissionTypeToPaymentDueType] ADD CONSTRAINT [FK_TRefCommissionTypeToPaymentDueTypeId_TRefPaymentDueType] FOREIGN KEY ([RefPaymentDueTypeId]) REFERENCES [dbo].[TRefPaymentDueType] ([RefPaymentDueTypeId])
GO
