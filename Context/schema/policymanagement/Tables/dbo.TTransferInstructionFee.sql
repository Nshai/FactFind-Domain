CREATE TABLE [dbo].[TTransferInstructionFee]
(
    [TransferInstructionFeeId] [int] NOT NULL IDENTITY(1,1),
    [PlanId] [int] NULL,
    [FeeId] [int] NULL,
    [TransferInstructionId] [int] NULL,
)
GO
ALTER TABLE [dbo].[TTransferInstructionFee] ADD CONSTRAINT [PK_TTransferInstructionFee] PRIMARY KEY CLUSTERED  ([TransferInstructionFeeId])
GO
ALTER TABLE [dbo].[TTransferInstructionFee] ADD CONSTRAINT [UQ_PlanId_FeeId_TransferInstructionId] UNIQUE ([PlanId], [FeeId], [TransferInstructionId])
GO
