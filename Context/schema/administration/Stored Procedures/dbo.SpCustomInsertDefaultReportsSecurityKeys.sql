SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomInsertDefaultReportsSecurityKeys]
@IndigoClientId bigint

AS


-- ###### SETUP REPORTS SECURITY #######

-- ### Manager
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 9,'Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 5,'Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 4,'Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 31,'Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 29,'Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 28,'Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 27,'Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 23,'Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 21,'Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 2,'Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 17,'Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 16,'Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 12,'Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 1,'Manager'

-- ### Compliance Manager
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 4,'Compliance Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 31,'Compliance Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 3,'Compliance Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 29,'Compliance Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 28,'Compliance Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 27,'Compliance Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 26,'Compliance Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 24,'Compliance Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 23,'Compliance Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 22,'Compliance Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 20,'Compliance Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 2,'Compliance Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 19,'Compliance Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 17,'Compliance Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 16,'Compliance Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 12,'Compliance Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 11,'Compliance Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 10,'Compliance Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 1,'Compliance Manager'

-- #### Adviser
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 9,'Adviser'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 5,'Adviser'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 31,'Adviser'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 29,'Adviser'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 28,'Adviser'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 27,'Adviser'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 21,'Adviser'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 2,'Adviser'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 17,'Adviser'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 12,'Adviser'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 1,'Adviser'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 77,'Adviser'

-- ### Paraplanner
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 9,'Paraplanner'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 5,'Paraplanner'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 31,'Paraplanner'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 29,'Paraplanner'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 28,'Paraplanner'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 27,'Paraplanner'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 21,'Paraplanner'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 2,'Paraplanner'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 17,'Paraplanner'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 12,'Paraplanner'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 1,'Paraplanner'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 77,'Paraplanner'

-- ### Commissions Manager
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 9,'Commissions Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 8,'Commissions Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 7,'Commissions Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 6,'Commissions Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 5,'Commissions Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 31,'Commissions Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 30,'Commissions Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 29,'Commissions Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 28,'Commissions Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 27,'Commissions Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 26,'Commissions Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 25,'Commissions Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 24,'Commissions Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 23,'Commissions Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 21,'Commissions Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 18,'Commissions Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 17,'Commissions Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 16,'Commissions Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 15,'Commissions Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 14,'Commissions Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 13,'Commissions Manager'
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 1,'Commissions Manager'

--### TnC Coach
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 31,'TnC Coach'	
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 29,'TnC Coach'	
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 28,'TnC Coach'	
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 27,'TnC Coach'	
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 22,'TnC Coach'	
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 20,'TnC Coach'	
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 2,'TnC Coach'	
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 19,'TnC Coach'	
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 17,'TnC Coach'	
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 12,'TnC Coach'	
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 11,'TnC Coach'	
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 10,'TnC Coach'	
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 1,'TnC Coach'	

-- ### Administrator
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 9,'Administrator'	
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 5,'Administrator'	
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 31,'Administrator'	
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 29,'Administrator'	
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 28,'Administrator'	
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 27,'Administrator'	
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 21,'Administrator'	
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 2,'Administrator'	
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 17,'Administrator'	
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 12,'Administrator'	
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 1,'Administrator'	
EXEC TD_SetReportKeyByIndigoClientId @IndigoClientId, 77,'Administrator'	
GO
