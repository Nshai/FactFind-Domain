CREATE TABLE [dbo].[TCriticalIllnessDetail]
(
[CriticalIllnessDetailId] [int] NOT NULL IDENTITY(1, 1),
[TotalPermanentDisability] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[CriticalIllnessCondition] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[CoverType] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[CriticalIllnessTPDAmount] [decimal] (19, 2) NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCriticalIllnessDetail_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TCriticalIllnessDetail] ADD CONSTRAINT [PK_TCriticalIllnessDetail] PRIMARY KEY CLUSTERED  ([CriticalIllnessDetailId])
GO
