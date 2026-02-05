CREATE TABLE [dbo].[TSecurityTransferInstructionFeeAudit]
(
    [AuditId] [int] NOT NULL IDENTITY(1, 1),
    [SecurityTransferInstructionFeeId] [int] NOT NULL,
    [PlanId] [int] NULL,
    [FeeId] [int] NULL,
    [SecurityTransferInstructionId] [int] NULL,
    [StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
    [StampDateTime] [datetime] NULL CONSTRAINT [DF_TSecurityTransferInstructionFeeAudit_StampDateTime] DEFAULT (getdate()),
    [StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSecurityTransferInstructionFeeAudit] ADD CONSTRAINT [PK_TSecurityTransferInstructionFeeAudit] PRIMARY KEY CLUSTERED ([AuditId]) WITH (FILLFACTOR=80)
GO
