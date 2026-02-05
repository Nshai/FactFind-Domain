CREATE TABLE [dbo].[TTransferInstructionFeeAudit]
(
    [AuditId] [int] NOT NULL IDENTITY(1, 1),
    [TransferInstructionFeeId] [int] NOT NULL,
    [PlanId] [int] NULL,
    [FeeId] [int] NULL,
    [TransferInstructionId] [int] NULL,
    [StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
    [StampDateTime] [datetime] NULL CONSTRAINT [DF_TTransferInstructionFeeAudit_StampDateTime] DEFAULT (getdate()),
    [StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TTransferInstructionFeeAudit] ADD CONSTRAINT [PK_TTransferInstructionFeeAudit] PRIMARY KEY CLUSTERED ([AuditId]) WITH (FILLFACTOR=80)
GO
