CREATE TABLE dbo.TPersonalContact2ClientAudit (
	[PersonalContact2ClientAuditId] int IDENTITY(1,1) NOT NULL CONSTRAINT PK_PersonalContact2ClientAuditId PRIMARY KEY,
	[PersonalContact2ClientId] int NOT NULL,
	[CRMContactId] int NOT NULL ,
	[PersonalContactId] int NOT NULL,
	[StampAction] [char] (1) NOT NULL,
	[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPersonalContact2Clients_StampDateTime] DEFAULT (getdate()),
	[StampUser] [varchar] (255) NULL
);