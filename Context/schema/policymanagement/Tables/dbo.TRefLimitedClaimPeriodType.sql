CREATE TABLE [dbo].[TRefLimitedClaimPeriodType]
(
[RefLimitedClaimPeriodTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefLimitedClaimPeriodType] ADD CONSTRAINT [PK_TRefLimitedClaimPeriodType] PRIMARY KEY CLUSTERED  ([RefLimitedClaimPeriodTypeId])
GO
