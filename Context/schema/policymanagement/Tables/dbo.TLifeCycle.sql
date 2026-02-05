CREATE TABLE [dbo].[TLifeCycle]
(
[LifeCycleId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[Descriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Status] [int] NOT NULL CONSTRAINT [DF_TLifeCycle_Status] DEFAULT ((0)),
[PreQueueBehaviour] [varchar] (150) COLLATE Latin1_General_CI_AS NULL,
[PostQueueBehaviour] [varchar] (150) COLLATE Latin1_General_CI_AS NULL,
[CreatedDate] [datetime] NULL,
[CreatedUser] [int] NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLifeCycle_ConcurrencyId] DEFAULT ((1)),
[IgnorePostCheckIfPreHasBeenCompleted] [bit] NULL CONSTRAINT [DF_TLifeCycle_IgnorePostCheckIfPreHasBeenCompleted] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TLifeCycle] ADD CONSTRAINT [PK_TLifeCycle] PRIMARY KEY CLUSTERED  ([LifeCycleId]) WITH (FILLFACTOR=80)
GO
