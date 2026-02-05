CREATE TABLE [dbo].[TSimplyBizSagaData]
(
[SimplyBizSagaDataId] [uniqueidentifier] NOT NULL,
[Originator] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NOT NULL,
[OriginalMessageId] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NOT NULL,
[TenantId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[ClientId] [int] NOT NULL,
[SecondaryClientId] [int] NULL,
[CreatedDate] [datetime] NOT NULL,
[IsDeleted] [bit] NOT NULL
)
GO
