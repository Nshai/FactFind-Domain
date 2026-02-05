CREATE TABLE [dbo].[TSecurityTransferInstructionFee]
(
    [SecurityTransferInstructionFeeId] [int] NOT NULL IDENTITY(1,1),
    [PlanId] [int] NULL,
    [FeeId] [int] NULL,
    [SecurityTransferInstructionId] [int] NULL,
)
GO
ALTER TABLE [dbo].[TSecurityTransferInstructionFee] ADD CONSTRAINT [PK_TSecurityTransferInstructionFee] PRIMARY KEY CLUSTERED  ([SecurityTransferInstructionFeeId])
GO
ALTER TABLE [dbo].[TSecurityTransferInstructionFee] ADD CONSTRAINT [UQ_PlanId_FeeId_SecurityTransferInstructionId] UNIQUE ([PlanId], [FeeId], [SecurityTransferInstructionId])
GO
