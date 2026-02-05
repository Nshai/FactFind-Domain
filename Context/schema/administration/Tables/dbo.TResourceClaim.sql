CREATE TABLE [dbo].[TResourceClaim]
(
[ResourceClaimId] [int] NOT NULL IDENTITY(1, 1),
[Resource] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Action] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TResourceClaim] ADD CONSTRAINT [PK_TResourceClaim] PRIMARY KEY CLUSTERED  ([ResourceClaimId])
GO
