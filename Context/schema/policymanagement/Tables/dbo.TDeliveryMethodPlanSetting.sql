CREATE TABLE [dbo].[TDeliveryMethodPlanSetting]
(
[PlanId] [int] NOT NULL,
[IsProposed] [bit] NOT NULL,
[DeliveryMethodOptionId] [int] NOT NULL,
[Status] [int] NOT NULL,
[StatusReason] [nvarchar] (500) COLLATE Latin1_General_CI_AS NULL,
[CreatedAt] [datetime] NULL,
[CreatedBy] [int] NULL,
[ModifiedAt] [datetime] NULL,
[ModifiedBy] [int] NULL,
[IsLockedByProviderSettingMismatch] [bit] NULL
)
GO
ALTER TABLE [dbo].[TDeliveryMethodPlanSetting] ADD CONSTRAINT [PK_TDeliveryMethodPlanSetting] PRIMARY KEY CLUSTERED ([PlanId], [IsProposed])
GO
ALTER TABLE [dbo].[TDeliveryMethodPlanSetting] ADD CONSTRAINT [FK_TPolicyBusiness_PolicyBusinessId_PlanId] FOREIGN KEY ([PlanId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO
ALTER TABLE [dbo].[TDeliveryMethodPlanSetting] ADD CONSTRAINT [FK_TDeliveryMethodOption_DeliveryMethodOptionId_DeliveryMethodOptionId] FOREIGN KEY ([DeliveryMethodOptionId]) REFERENCES [dbo].[TDeliveryMethodOption] ([DeliveryMethodOptionId])
GO
ALTER TABLE [dbo].[TDeliveryMethodPlanSetting] ADD CONSTRAINT [FK_TDeliveryMethodChangeStatus_DeliveryMethodChangeStatusId_Status] FOREIGN KEY ([Status]) REFERENCES [dbo].[TDeliveryMethodChangeStatus] ([DeliveryMethodChangeStatusId])
GO