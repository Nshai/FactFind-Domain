CREATE TABLE [dbo].[TUserBilling]
(
[UserBillingId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[HourlyBillingRate] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TUserBilling_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TUserBilling] ADD CONSTRAINT [PK_TUserBilling] PRIMARY KEY CLUSTERED  ([UserBillingId])
GO
CREATE NONCLUSTERED INDEX [IX_TUserBilling_UserId] ON [dbo].[TUserBilling] ([UserId])
GO
ALTER TABLE [dbo].[TUserBilling] WITH CHECK ADD CONSTRAINT [FK_TUser_TUserBilling] FOREIGN KEY ([UserId]) REFERENCES [dbo].[TUser] ([UserId])
GO
