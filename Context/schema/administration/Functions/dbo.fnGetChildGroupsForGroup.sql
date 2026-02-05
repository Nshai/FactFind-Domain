SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE FUNCTION [dbo].[fnGetChildGroupsForGroup]  
(    
 @GroupId as BIGINT = 0,    
 @UserId as bigint = 0    
)    
    
RETURNS @Group TABLE     
(    
 GroupId bigint PRIMARY KEY,    
 Identifier varchar(64)    
)    
    
AS    
BEGIN    
    
DECLARE @SuperUser bit, @IndigoClientId bigint  
  
 IF @UserId > 0     
 SELECT @GroupId = GroupId, @SuperUser = SuperUser, @IndigoClientId = IndigoClientId FROM TUser WHERE UserId = @UserId    
  
  
 IF ISNULL(@SuperUser,0) = 1  
 BEGIN  
 INSERT INTO @Group    
 SELECT g1.GroupId, g1.Identifier    
 FROM administration..TGroup g1    
 WHERE g1.IndigoClientid = @IndigoClientId  
 END  
 ELSE  
 BEGIN    
  INSERT INTO @Group    
  SELECT g1.GroupId, g1.Identifier    
  FROM administration..TGroup g1    
  WHERE g1.GroupId = @GroupId    
      
  INSERT INTO @Group    
  select g2.groupid, g2.identifier    
  from tgroup g1    
  left join tgroup g2 on g1.groupid = g2.parentid    
  where g1.groupid = @GroupId    
  AND g2.GroupId IS NOT NULL    
  GROUP BY g2.GroupiD, g2.Identifier    
     
  INSERT INTO @Group    
  select g3.groupid, g3.identifier    
  from tgroup g1    
  left join tgroup g2 on g1.groupid = g2.parentid    
  left join tgroup g3 on g2.groupid = g3.parentid    
  where g1.groupid = @GroupId    
  AND g3.GroupId IS NOT NULL    
  GROUP BY g3.GroupiD, g3.Identifier    
     
  INSERT INTO @Group    
  select g4.groupid, g4.identifier    
  from tgroup g1    
  left join tgroup g2 on g1.groupid = g2.parentid    
  left join tgroup g3 on g2.groupid = g3.parentid    
  left join tgroup g4 on g3.groupid = g4.parentid    
  where g1.groupid = @GroupId    
  AND g4.GroupId IS NOT NULL    
  GROUP BY g4.GroupiD, g4.Identifier    
     
  INSERT INTO @Group    
  select g5.groupid, g5.identifier    
  from tgroup g1    
  left join tgroup g2 on g1.groupid = g2.parentid    
  left join tgroup g3 on g2.groupid = g3.parentid    
  left join tgroup g4 on g3.groupid = g4.parentid    
  left join tgroup g5 on g4.groupid = g5.parentid    
  where g1.groupid = @GroupId    
  AND g5.GroupId IS NOT NULL    
  GROUP BY g5.GroupiD, g5.Identifier    
 END  
    
 RETURN    
END    
    
    
    
    
    
    
    
  
GO
