CREATE TABLE [dbo].[TTransferEligibility]
(
    [TransferEligibilityId] [int] NOT NULL IDENTITY(1, 1),
    [TargetProductProviderId] [int] NOT NULL,
    [TargetPlanTypeId] [int] NOT NULL,
    [SourcePlanTypeId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TTransferEligibility] ADD CONSTRAINT [PK_TTransferEligibility_TransferEligibilityId] PRIMARY KEY CLUSTERED  ([TransferEligibilityId])
GO