CREATE TABLE [dbo].[TDeliveryMethodChangeStatus]
(
[DeliveryMethodChangeStatusId] [int] NOT NULL,
[Name] [nvarchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
)
GO

ALTER TABLE [dbo].[TDeliveryMethodChangeStatus] ADD CONSTRAINT [PK_TDeliveryMethodChangeStatus] PRIMARY KEY CLUSTERED ([DeliveryMethodChangeStatusId])
GO