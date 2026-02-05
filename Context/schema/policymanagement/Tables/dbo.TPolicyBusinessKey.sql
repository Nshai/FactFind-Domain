CREATE TABLE [dbo].[TPolicyBusinessKey]
(
	UserID INT NOT NULL,
	GroupId INT NOT NULL,
	RightMask INT NOT NULL, 
	AdvancedMask INT NOT NULL
)
GO

CREATE CLUSTERED INDEX [IX_TPolicyBusinessKey_UserId] ON [dbo].[TPolicyBusinessKey]
(
	[UserID] ASC
)
GO