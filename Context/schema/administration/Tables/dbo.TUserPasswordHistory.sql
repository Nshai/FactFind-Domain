CREATE TABLE [dbo].[TUserPasswordHistory]
(
	[UserPasswordHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[Salt] [nvarchar](4000) NOT NULL,
	[PasswordHash] [nvarchar](4000) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	CONSTRAINT [PK_TUserPasswordHistory] PRIMARY KEY NONCLUSTERED 
	(
		[UserPasswordHistoryId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[TUserPasswordHistory] ADD  CONSTRAINT [DF_TUserPasswordHistory_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

CREATE CLUSTERED INDEX IX_TUserPasswordHistory_UserId_CreatedDate_PasswordHistoryId
	ON [dbo].[TUserPasswordHistory] (UserId, CreatedDate, UserPasswordHistoryId)
	--INCLUDE (PasswordHistoryId, Salt, PasswordHash)
GO

