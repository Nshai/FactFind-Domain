CREATE TABLE dbo.TPersonalContact2Client (
	[PersonalContact2ClientId] int IDENTITY(1,1) NOT NULL CONSTRAINT PK_PersonalContact2ClientId PRIMARY KEY,
	[CRMContactId] int NOT NULL  CONSTRAINT FK_CRMContactId2 FOREIGN KEY (CRMContactId) REFERENCES TCRMContact(CRMContactId),
	[PersonalContactId] int NOT NULL  CONSTRAINT FK_PersonalContactId2 FOREIGN KEY (PersonalContactId) REFERENCES TPersonalContact(PersonalContactId),
);