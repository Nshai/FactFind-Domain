CREATE TABLE dbo.TPersonalContactAudit (
	[PersonalContactAuditId] int IDENTITY(1,1) NOT NULL CONSTRAINT PK_PersonalContactAuditId PRIMARY KEY,
	[PersonalContactId] int NOT NULL,
	[CRMContactId] int NOT NULL,
	[IndigoClientId] int NOT NULL,
	[StampAction] [char] (1) NOT NULL,
	[StampDateTime] [datetime] NULL CONSTRAINT [DF_TTPersonalContactAudit_StampDateTime] DEFAULT (getdate()),
	[StampUser] [varchar] (255) NULL
); 