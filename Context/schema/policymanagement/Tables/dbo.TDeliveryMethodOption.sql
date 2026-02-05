CREATE TABLE [dbo].[TDeliveryMethodOption]
(
[DeliveryMethodOptionId] [int] NOT NULL,
[Name] [nvarchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
)
GO
ALTER TABLE [dbo].[TDeliveryMethodOption] ADD CONSTRAINT [PK_TDeliveryMethodOption] PRIMARY KEY CLUSTERED ([DeliveryMethodOptionId])
GO