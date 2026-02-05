SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpCustomGetUserStatsForIndigoClient]     
@IndigoClientId bigint    
AS    
  
DECLARE @AGNLI varchar(50)    
DECLARE @AGLI varchar(50)    
DECLARE @AGLO varchar(50)    
DECLARE @AD varchar(50)    
    
SET @AGNLI='Access Granted - Not Logged In'    
SET @AGLI='Access Granted - Logged In'    
SET @AGLO='Access Granted - Locked'    
SET @AD='Access Denied - Not Logged In'    
  
    
SELECT      
 1 as tag,    
 NULL as parent,     
 T1.IndigoClientId as [IndigoClient!1!IndigoClientId],    
 ISNULL(T3.AccessGranted,0)AS [IndigoClient!1!AccessGranted],    
 ISNULL(T4.AccessDenied,0)AS [IndigoClient!1!AccessDenied],    
 T5.LastLogin AS [IndigoClient!1!LastLogin]    
    
 FROM TIndigoClient T1    
    
 LEFT OUTER JOIN(    
   SELECT     
   COUNT(IndigoClientId) as 'AccessGranted',    
   IndigoClientId     
   FROM TUser T2 with(nolock)     
   WHERE (T2.Status=@AGNLI OR T2.status=@AGLI OR T2.status=@AGLO)
   AND t2.IndigoClientId = @IndigoClientId And T2.RefUserTypeId = 1   
   GROUP BY IndigoClientId)     
 T3 ON T1.IndigoClientId=T3.IndigoClientId    
    
 LEFT OUTER JOIN    
  (    
   SELECT     
   COUNT(IndigoClientId) as 'AccessDenied',    
   IndigoClientId     
   FROM TUser T2 with(nolock)      
   WHERE T2.status=@AD    
   AND t2.IndigoClientId = @IndigoClientId And T2.RefUserTypeId = 1  
   GROUP BY IndigoClientId    
  ) T4 ON T1.IndigoClientId=T3.IndigoClientId    
    
 LEFT OUTER JOIN    
  (    
   SELECT TOP 1 DATENAME(DAY,T2.logondatetime)+ ' ' + DATENAME(MONTH,T2.logondatetime) + ' ' +     
   DATENAME(YEAR,T2.logondatetime)+ ' ' + DATENAME(HOUR,T2.logondatetime)+ ':' +     
   DATENAME(MINUTE,T2.logondatetime)AS 'LastLogin',T3.IndigoClientId     
   from TLogon T2 WITH(NOLOCK)    
   JOIN TUser T3 WITH(NOLOCK) ON T2.UserId=T3.Userid     
   WHERE T3.IndigoClientId=@IndigoClientId    
   AND T2.Type='application'    
   ORDER BY T2.LogonId DESC    
  ) T5 ON T1.IndigoClientId=T5.IndigoClientId    
    
WHERE T1.IndigoClientId=@IndigoClientId    
    
FOR XML EXPLICIT  
GO
